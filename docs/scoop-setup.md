# Scoop Installation Setup

This document outlines the Scoop package installation setup for MCP Router on Windows.

## Overview

Scoop is a command-line installer for Windows that makes it easy to install applications without needing an GUI. MCP Router supports installation via Scoop.

## Installation Process

### User Installation

Users can install MCP Router using Scoop with the following commands:

```bash
scoop bucket add mcp-router https://github.com/mcp-router/scoop-bucket
scoop install mcp-router
```

### Prerequisites for Scoop

- Windows 7 or later
- PowerShell 5.0 or later
- `.NET Framework 4.5+` (for some applications)

## Development Setup

### Manifest Structure

The Scoop manifest is stored in `/scoop/mcp-router.json` and contains:

- **version**: Application version (must match the release version)
- **architecture.64bit.url**: Direct URL to the MSI installer
- **architecture.64bit.hash**: SHA256 hash of the MSI installer
- **installer/uninstaller**: PowerShell scripts for installation/uninstallation

### Automated Manifest Updates

The manifest is automatically updated during the release process via GitHub Actions:

1. When a new release is published on GitHub
2. `scoop-update.yml` workflow extracts the MSI from the release
3. Calculates the SHA256 hash
4. Updates `/scoop/mcp-router.json` with the new version and hash
5. The manifest is committed to the repository

### Manual Manifest Update

If you need to update the manifest manually, edit `/scoop/mcp-router.json`:

```json
{
  "version": "0.6.1",
  "description": "A Unified MCP Server Management App",
  "homepage": "https://github.com/mcp-router/mcp-router",
  "license": "Sustainable Use License",
  "architecture": {
    "64bit": {
      "url": "https://github.com/mcp-router/mcp-router/releases/download/v0.6.1/MCP-Router-0.6.1.msi",
      "hash": "sha256:ACTUAL_HASH_HERE"
    }
  },
  ...
}
```

### External Scoop Bucket

The external Scoop bucket is maintained at: https://github.com/mcp-router/scoop-bucket

Users add this bucket with:
```bash
scoop bucket add mcp-router https://github.com/mcp-router/scoop-bucket
```

## Validation

To validate the Scoop manifest is properly formatted:

```bash
node tools/validate-scoop-manifest.js
```

This checks:
- All required fields are present
- SHA256 hash format is correct
- URL is valid
- Version is specified

## Manifest Distribution

### Option 1: Direct Repository (Current)

The manifest is stored and updated in this repository at `/scoop/mcp-router.json`. External bucket repositories can pull from here.

### Option 2: Separate Bucket Repository

For a dedicated bucket, follow the Scoop bucket guidelines:
1. Create a `scoop-bucket` repository
2. Place manifests in `/bucket/` directory
3. Users add with: `scoop bucket add mcp-router https://github.com/mcp-router/scoop-bucket`

## Release Checklist

When creating a new release for Windows:

1. ✅ Build MSI installer (`pnpm make` on Windows)
2. ✅ Upload MSI to GitHub Releases
3. ✅ The `scoop-update.yml` workflow runs automatically
4. ✅ Verify manifest was updated with correct hash and version
5. ✅ Test installation: `scoop install mcp-router`

## Troubleshooting

### MSI Not Found in Release
- Ensure the Windows build was completed and MSI was uploaded
- Check GitHub Actions logs in `scoop-update.yml`

### Hash Mismatch
- The hash is calculated from the downloaded MSI
- If it fails, manually calculate: `(Get-FileHash path\to\file.msi -Algorithm SHA256).Hash`

### Manifest Validation Fails
- Run: `node tools/validate-scoop-manifest.js`
- Check JSON formatting with: `cat scoop/mcp-router.json | jq`

## References

- [Scoop Documentation](https://scoop.sh/)
- [Scoop Bucket Format](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
- [App Manifest Format](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifest-Format)
