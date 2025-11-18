#!/bin/bash
set -e

# Script to update the external scoop-bucket repository with the latest manifest

VERSION="${1:-}"
MSI_URL="${2:-}"
SHA256_HASH="${3:-}"

if [ -z "$VERSION" ] || [ -z "$MSI_URL" ] || [ -z "$SHA256_HASH" ]; then
  echo "Usage: $0 <version> <msi-url> <sha256-hash>"
  exit 1
fi

SCOOP_BUCKET_REPO="https://github.com/mcp-router/scoop-bucket.git"
BUCKET_TEMP_DIR=$(mktemp -d)

echo "Cloning scoop-bucket repository..."
git clone "$SCOOP_BUCKET_REPO" "$BUCKET_TEMP_DIR"

cd "$BUCKET_TEMP_DIR"

echo "Updating mcp-router.json manifest..."
cat > bucket/mcp-router.json << EOF
{
  "version": "$VERSION",
  "description": "A Unified MCP Server Management App",
  "homepage": "https://github.com/mcp-router/mcp-router",
  "license": "Sustainable Use License",
  "architecture": {
    "64bit": {
      "url": "$MSI_URL",
      "hash": "sha256:$SHA256_HASH"
    }
  },
  "pre_install": "if (!(Test-Path \"\$persist_dir\")) { New-Item -ItemType Directory -Path \"\$persist_dir\" -Force | Out-Null }",
  "installer": {
    "script": [
      "Start-Process msiexec.exe -ArgumentList @('/i', \"\$file\", '/qn', '/norestart') -Wait"
    ]
  },
  "uninstaller": {
    "script": [
      "Start-Process msiexec.exe -ArgumentList @('/x', (Get-Item (Get-ItemProperty -Path @('HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*', 'HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*', 'HKLM:\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*') | Where-Object { \$_.DisplayName -like '*MCP Router*' }).UninstallString).Name, '/qn', '/norestart') -Wait"
    ]
  },
  "shortcuts": [
    [
      "MCP Router.exe",
      "MCP Router"
    ]
  ]
}
EOF

git config user.name "GitHub Actions"
git config user.email "actions@github.com"
git add bucket/mcp-router.json
git commit -m "Update mcp-router manifest to v$VERSION"

echo "Pushing to scoop-bucket repository..."
git push origin main

echo "✓ Scoop manifest updated successfully"

cd -
rm -rf "$BUCKET_TEMP_DIR"
