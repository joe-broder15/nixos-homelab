#!/usr/bin/env bash
set -euo pipefail

# Pull latest changes for this repository and rebuild the system.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Using repository at ${REPO_ROOT}"
sudo git -C "${REPO_ROOT}" pull --ff-only

echo "Rebuilding system configuration"
sudo nixos-rebuild switch

echo "Rebuild complete"

