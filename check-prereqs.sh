#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
export PATH="$PWD/toolchain/bin:$PATH"

required=(func fift)
missing=()

for cmd in "${required[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if [ "${#missing[@]}" -ne 0 ]; then
  echo "Missing required commands: ${missing[*]}" >&2
  echo
  echo "Please install the TON toolchain and ensure these commands are available on PATH." >&2
  echo "Typical install sources depend on your environment, for example:" >&2
  echo "  export PATH=\"/path/to/ton-toolchain/bin:\$PATH\"" >&2
  echo
  echo "Once installed, rerun this script from the repository root:" >&2
  echo "  ./check-prereqs.sh" >&2
  exit 1
fi

echo "All required tools are available: ${required[*]}"

