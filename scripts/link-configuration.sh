#!/usr/bin/env bash
set -euo pipefail

# Resolve repository root relative to this script.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="${REPO_ROOT}/configuration.nix"
TARGET="/etc/nixos/configuration.nix"

if [[ ! -f "${SOURCE}" ]]; then
  echo "configuration.nix not found at ${SOURCE}" >&2
  exit 1
fi

echo "Linking ${TARGET} -> ${SOURCE}"
sudo ln -sf "${SOURCE}" "${TARGET}"
echo "Done. Verify with: ls -l ${TARGET}"

