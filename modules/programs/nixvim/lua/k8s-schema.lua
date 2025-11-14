-- K8s CRD Schema Helper
local M = {}

M.config = {
  schemas_catalog = 'datreeio/CRDs-catalog',
  schema_catalog_branch = 'main',
  github_base_api_url = 'https://api.github.com/repos',
  github_headers = {
    Accept = 'application/vnd.github+json',
    ['X-GitHub-Api-Version'] = '2022-11-28',
  },
}

M.schema_url = 'https://raw.githubusercontent.com/'
  .. M.config.schemas_catalog .. '/'
  .. M.config.schema_catalog_branch

-- Parse YAML documents from buffer
M.parse_documents = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local documents = {}
  local current_doc = { start_line = 1, lines = {} }

  for line_num, line in ipairs(lines) do
    -- Document separator
    if line:match('^%-%-%-') then
      if #current_doc.lines > 0 then
        current_doc.end_line = line_num - 1
        table.insert(documents, current_doc)
      end
      current_doc = { start_line = line_num + 1, lines = {} }
    else
      table.insert(current_doc.lines, line)
    end
  end

  -- Add the last document
  if #current_doc.lines > 0 then
    current_doc.end_line = #lines
    table.insert(documents, current_doc)
  end

  return documents
end

-- Extract apiVersion and kind from document lines
M.extract_metadata = function(doc_lines)
  local api_version, kind

  for _, line in ipairs(doc_lines) do
    if not api_version then
      local match = line:match('^apiVersion:%s*(.+)$')
      if match then
        api_version = vim.trim(match)
      end
    end

    if not kind then
      local match = line:match('^kind:%s*(.+)$')
      if match then
        kind = vim.trim(match)
      end
    end

    -- Stop searching once we have both
    if api_version and kind then
      break
    end
  end

  return api_version, kind
end

-- Check if line range has a schema modeline
M.has_modeline_at = function(start_line, end_line)
  -- Check first 3 lines of the document
  local check_end = math.min(start_line + 2, end_line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, check_end, false)

  for _, line in ipairs(lines) do
    if line:match('^# yaml%-language%-server: %$schema=') then
      return true
    end
  end
  return false
end

-- Build schema path from apiVersion and kind
-- Pattern: {group}/{kind}_{version}.json
-- Example: traefik.io/v1alpha1 + IngressRoute -> traefik.io/ingressroute_v1alpha1.json
M.build_schema_path = function(api_version, kind)
  if not api_version or not kind then
    return nil
  end

  -- Extract group and version
  local group, version = api_version:match('^([^/]+)/(.+)$')
  if not group then
    -- Core resources like "v1" don't have a group
    return nil
  end

  -- Convert kind to lowercase
  local kind_lower = kind:lower()

  -- Build path: group/kind_version.json
  return group .. '/' .. kind_lower .. '_' .. version .. '.json'
end

-- List all CRD schemas from GitHub
M.list_github_tree = function()
  local curl = require('plenary.curl')
  local url = M.config.github_base_api_url
    .. '/' .. M.config.schemas_catalog
    .. '/git/trees/' .. M.config.schema_catalog_branch

  local response = curl.get(url, {
    headers = M.config.github_headers,
    query = { recursive = 1 }
  })

  if response.status ~= 200 then
    vim.notify('Failed to fetch CRD catalog: ' .. response.status, vim.log.levels.ERROR)
    return {}
  end

  local body = vim.fn.json_decode(response.body)
  local schemas = {}

  for _, tree in ipairs(body.tree) do
    if tree.type == 'blob' and tree.path:match('%.json$') then
      schemas[tree.path] = true
    end
  end

  return schemas
end

-- Add schema modeline at specific line
M.add_modeline_at = function(line_num, schema_path)
  local schema_url = M.schema_url .. '/' .. schema_path
  local schema_modeline = '# yaml-language-server: $schema=' .. schema_url

  -- Insert at the specified line (0-indexed for the API)
  vim.api.nvim_buf_set_lines(0, line_num - 1, line_num - 1, false, { schema_modeline })
  return schema_modeline
end

-- Main function to add schemas
M.add_schema = function()
  -- Get all CRD schemas from catalog
  local all_schemas = M.list_github_tree()
  if vim.tbl_count(all_schemas) == 0 then
    vim.notify('Failed to load CRD catalog', vim.log.levels.ERROR)
    return
  end

  -- Parse documents from buffer
  local documents = M.parse_documents()
  if #documents == 0 then
    vim.notify('No YAML documents found in buffer', vim.log.levels.WARN)
    return
  end

  local added_count = 0
  local skipped_count = 0
  local failed_count = 0
  local offset = 0 -- Track line offset as we add modelines

  for _, doc in ipairs(documents) do
    local start_line = doc.start_line + offset

    -- Check if already has modeline
    if M.has_modeline_at(start_line, doc.end_line + offset) then
      skipped_count = skipped_count + 1
    else
      -- Extract metadata
      local api_version, kind = M.extract_metadata(doc.lines)

      if api_version and kind then
        -- Build expected schema path
        local schema_path = M.build_schema_path(api_version, kind)

        if schema_path and all_schemas[schema_path] then
          -- Add modeline
          M.add_modeline_at(start_line, schema_path)
          added_count = added_count + 1
          offset = offset + 1 -- Account for added line
          vim.notify('Added schema for ' .. kind .. ' (' .. schema_path .. ')', vim.log.levels.INFO)
        else
          failed_count = failed_count + 1
          vim.notify(
            'Schema not found for ' .. kind .. ' with apiVersion ' .. api_version,
            vim.log.levels.WARN
          )
        end
      else
        failed_count = failed_count + 1
        vim.notify('Could not extract apiVersion/kind from document at line ' .. start_line, vim.log.levels.WARN)
      end
    end
  end

  -- Summary
  local summary = string.format(
    'Schema update complete: %d added, %d skipped, %d failed',
    added_count, skipped_count, failed_count
  )
  vim.notify(summary, vim.log.levels.INFO)
end

-- Register command
vim.api.nvim_create_user_command('K8sAddSchema', M.add_schema, {
  desc = 'Add yaml-language-server schema modeline for K8s CRDs'
})
