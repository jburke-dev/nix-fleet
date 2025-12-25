{ delib, ... }:
delib.module {
  name = "programs.nixvim.opts";

  home.ifEnabled.programs.nixvim = {
    autoGroups = {
      NumberToggle = { };
    };
    autoCmd = [
      {
        event = [
          "BufEnter"
          "FocusGained"
          "InsertLeave"
          "WinEnter"
        ];
        group = "NumberToggle";
        callback = {
          __raw = "function() if vim.api.nvim_get_mode().mode ~= 'i' then vim.opt.relativenumber = true end end";
        };
      }
      {
        event = [
          "BufLeave"
          "FocusLost"
          "InsertEnter"
          "WinLeave"
        ];
        group = "NumberToggle";
        callback = {
          __raw = "function() vim.opt.relativenumber = false end";
        };
      }
      {
        event = [ "VimEnter" ];
        callback = {
          __raw = "function() if vim.fn.argv(0) == '' then vim.defer_fn(function() vim.cmd('Oil') end, 0) end end";
        };
      }
      {
        event = [ "CursorHold" ];
        callback = {
          __raw = "function() vim.diagnostic.open_float(nil, { focusable = false, scope = 'cursor' }) end";
        };
      }
      {
        event = [ "VimResized" ];
        command = "wincmd =";
      }
      {
        event = [
          "BufRead"
          "BufNewFile"
        ];
        pattern = "*.tf";
        callback = {
          __raw = "function() vim.bo.filetype = 'terraform' end";
        };
      }
    ];
  };
}
