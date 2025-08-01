#!/bin/bash
set -euo pipefail
script_dirpath="$(cd "$(dirname "${0}")" && pwd)"

# Build the Go binary
echo "Building Go CLI tool..."
cd "${script_dirpath}"
go build -o build/cli-tool .

echo "Build complete! Binary available at: ${script_dirpath}/build/cli-tool"