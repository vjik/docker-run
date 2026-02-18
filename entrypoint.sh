#!/usr/bin/env sh
set -eu

username=${INPUT_USERNAME-}
password=${INPUT_PASSWORD-}
registry=${INPUT_REGISTRY-}
if [ -n "$username" ] || [ -n "$password" ] || [ -n "$registry" ]; then
  if [ -z "$username" ] || [ -z "$password" ] || [ -z "$registry" ]; then
    echo "Error: username, password and registry must be all set or all unset." >&2
    exit 1
  fi
  printf '%s' "$password" | docker login "$registry" -u "$username" --password-stdin
fi

inputOptions="--rm ${INPUT_OPTIONS-}"

command=$(printf '%s' "$INPUT_COMMAND" | tr '\n' ';')

# shellcheck disable=SC2086
exec docker run --rm \
    ${inputOptions} \
    "$INPUT_IMAGE" \
    sh -c "$command"
