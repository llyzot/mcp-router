param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "scoop-bucket",
    
    [Parameter(Mandatory=$false)]
    [string]$LocalPath = "."
)

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/${Username}/${RepoName}.git"
$LocalDir = Join-Path $LocalPath $RepoName

Write-Host "╔════════════════════════════════════════════════════════════════╗"
Write-Host "║           SCOOP BUCKET REPOSITORY SETUP                       ║"
Write-Host "╚════════════════════════════════════════════════════════════════╝"
Write-Host ""
Write-Host "Repository: $RepoUrl"
Write-Host "Local Path: $LocalDir"
Write-Host ""

# Check if directory already exists
if (Test-Path $LocalDir) {
    Write-Host "⚠️  Directory already exists: $LocalDir"
    $choice = Read-Host "Do you want to remove it and create a fresh one? (y/n)"
    
    if ($choice -eq 'y' -or $choice -eq 'Y') {
        Remove-Item -Recurse -Force $LocalDir
    } else {
        Write-Host "❌ Aborted."
        exit 1
    }
}

Write-Host "Creating directory structure..."
$null = New-Item -ItemType Directory -Path "$LocalDir/bucket" -Force

Push-Location $LocalDir

Write-Host "Initializing git repository..."
git init
git config user.name "Scoop Bucket Maintainer"
git config user.email "scoop@example.com"

Write-Host "Creating README.md..."
$readmeContent = @"
# Scoop Bucket

A Scoop bucket for MCP Router and related applications.

## Installation

``````bash
scoop bucket add mcp-router https://github.com/$Username/scoop-bucket
scoop install mcp-router
``````

## Available Packages

- **mcp-router** - MCP Router desktop application

## Updating

``````bash
scoop update mcp-router
``````

## Development

To add or update an application manifest, edit the corresponding JSON file in the ``bucket/`` directory.

### Manifest Format

``````json
{
  "version": "1.0.0",
  "description": "Application description",
  "homepage": "https://github.com/example/app",
  "license": "License Name",
  "architecture": {
    "64bit": {
      "url": "https://github.com/.../app-1.0.0.msi",
      "hash": "sha256:abcd1234..."
    }
  },
  "installer": {
    "script": ["..."]
  },
  "uninstaller": {
    "script": ["..."]
  }
}
``````

## References

- [Scoop Documentation](https://scoop.sh/)
- [Scoop Bucket Guidelines](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
- [App Manifest Format](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifest-Format)
"@

$readmeContent | Out-File -FilePath "README.md" -Encoding UTF8

Write-Host "Creating .gitignore..."
$gitignoreContent = @"
# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Temp
*.tmp
*.temp
tmp/
"@

$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8

Write-Host "Creating bucket directory structure..."
$bucketReadmeContent = @"
# Bucket Manifests

This directory contains Scoop application manifests in JSON format.

Each file corresponds to one application that can be installed via Scoop.
"@

$bucketReadmeContent | Out-File -FilePath "bucket/README.md" -Encoding UTF8

Write-Host "Creating initial commit..."
git add .
git commit -m "Initial commit: Scoop bucket structure"

Pop-Location

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗"
Write-Host "║                    ✅ SETUP COMPLETE                          ║"
Write-Host "╚════════════════════════════════════════════════════════════════╝"
Write-Host ""
Write-Host "📁 Repository initialized at: $LocalDir"
Write-Host ""
Write-Host "📝 Next steps:"
Write-Host ""
Write-Host "1. Push to GitHub:"
Write-Host "   cd $LocalDir"
Write-Host "   git remote add origin $RepoUrl"
Write-Host "   git branch -M main"
Write-Host "   git push -u origin main"
Write-Host ""
Write-Host "2. Add your first manifest:"
Write-Host "   copy mcp-router.json bucket/"
Write-Host "   git add bucket/mcp-router.json"
Write-Host "   git commit -m 'Add mcp-router manifest'"
Write-Host "   git push"
Write-Host ""
Write-Host "3. Users can then install with:"
Write-Host "   scoop bucket add mcp-router $RepoUrl"
Write-Host "   scoop install mcp-router"
Write-Host ""
