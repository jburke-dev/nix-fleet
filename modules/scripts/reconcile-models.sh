#!/usr/bin/env bash
set -e

OLLAMA_HOST=${OLLAMA_HOST:-"https://ollama.apps.chesurah.net"}
MODELS_YAML=${MODELS_YAML:-"./models.yaml"}

if [[ ! -f "$MODELS_YAML" ]]; then
  echo "$MODELS_YAML does not exist." 
  exit 1
fi

# TODO: set a timeout for this
until curl -sf "$OLLAMA_HOST"/api/version > /dev/null; do
  echo "Waiting for Ollama service..."
  sleep 5
done

echo "=== Fetching current models ==="
current_models=$(curl -sf "$OLLAMA_HOST"/api/tags | jq '[.models.[].name]')
echo "$current_models"

echo "=== Checking model configuration ==="
# it would be nice to do some yq/jq magic and have all this in one call, but the ollama api only seems
# to support pulling / removing one model at a time anyway
enabled_models=$(yq '[.[] | select(.enabled) | .name]' "$MODELS_YAML")
disabled_models=$(yq '[.[] | select(.enabled | not) | .name]' "$MODELS_YAML")

echo "=== Models to remove ==="
models_to_remove=$(jq -n --argjson disabled "$disabled_models" --argjson current "$current_models" '$current | map(select(. as $m | $disabled | index($m))) | .[]')
echo "$models_to_remove"
for model in $models_to_remove; do
  jq -n --arg model "$model" '{ "model": $model | fromjson }' -c -r | curl -X DELETE "$OLLAMA_HOST"/api/delete --json @-
  sleep 1
done

echo "=== Models to pull ==="
models_to_pull=$(jq -n --argjson enabled "$enabled_models" --argjson current "$current_models" '$enabled - $current | .[]')
echo "$models_to_pull"
for model in $models_to_pull; do
  jq -n --arg model "$model" '{ "model": $model | fromjson }' -c -r | curl "$OLLAMA_HOST"/api/pull --json @-
  sleep 1
done

echo "=== Updated models ==="
curl -sf "$OLLAMA_HOST"/api/tags | jq '.'
