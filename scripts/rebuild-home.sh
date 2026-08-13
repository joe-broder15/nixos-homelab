#!/usr/bin/env bash
set -euo pipefail

# Switch to a selected local Home Manager config using the working tree as-is (no git pull).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <homeConfiguration-name>" >&2
  echo "Example: $0 zircon" >&2
  exit 1
fi

CONFIG_NAME="$1"

home-manager switch --flake "${REPO_ROOT}#${CONFIG_NAME}"
