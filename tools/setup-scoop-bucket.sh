#!/bin/bash
# Setup script for creating and initializing a Scoop bucket repository
# Usage: ./tools/setup-scoop-bucket.sh <github-username> <repo-name>

set -e

USERNAME="${1:-}"
REPO_NAME="${2:-scoop-bucket}"
REPO_PATH="${3:-.}"

if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <github-username> [repo-name] [local-path]"
  echo ""
  echo "Examples:"
  echo "  $0 llyzot                    # Creates scoop-bucket repo"
  echo "  $0 llyzot my-bucket /tmp     # Creates my-bucket repo in /tmp"
  exit 1
fi

REPO_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"
LOCAL_DIR="${REPO_PATH}/${REPO_NAME}"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           SCOOP BUCKET REPOSITORY SETUP                       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Repository: ${REPO_URL}"
echo "Local Path: ${LOCAL_DIR}"
echo ""

# Check if directory already exists
if [ -d "$LOCAL_DIR" ]; then
  echo "⚠️  Directory already exists: $LOCAL_DIR"
  read -p "Do you want to remove it and create a fresh one? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$LOCAL_DIR"
  else
    echo "❌ Aborted."
    exit 1
  fi
fi

echo "Creating directory structure..."
mkdir -p "$LOCAL_DIR/bucket"

cd "$LOCAL_DIR"

# Initialize git repository
echo "Initializing git repository..."
git init
git config user.name "Scoop Bucket Maintainer"
git config user.email "scoop@example.com"

# Create README
echo "Creating README.md..."
cat > README.md << 'EOF'
# Scoop Bucket

A Scoop bucket for MCP Router and related applications.

## Installation

```bash
scoop bucket add mcp-router https://github.com/llyzot/scoop-bucket
scoop install mcp-router
```

## Available Packages

- **mcp-router** - MCP Router desktop application

## Updating

```bash
scoop update mcp-router
```

## Development

To add or update an application manifest, edit the corresponding JSON file in the `bucket/` directory.

### Manifest Format

```json
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
```

## References

- [Scoop Documentation](https://scoop.sh/)
- [Scoop Bucket Guidelines](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
- [App Manifest Format](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifest-Format)
EOF

# Create .gitignore
echo "Creating .gitignore..."
cat > .gitignore << 'EOF'
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
EOF

# Create initial bucket/README.md
echo "Creating bucket directory structure..."
cat > bucket/README.md << 'EOF'
# Bucket Manifests

This directory contains Scoop application manifests in JSON format.

Each file corresponds to one application that can be installed via Scoop.
EOF

# Initial commit
echo "Creating initial commit..."
git add .
git commit -m "Initial commit: Scoop bucket structure"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ SETUP COMPLETE                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📁 Repository initialized at: $LOCAL_DIR"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Push to GitHub:"
echo "   cd $LOCAL_DIR"
echo "   git remote add origin ${REPO_URL}"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "2. Add your first manifest:"
echo "   cp mcp-router.json bucket/"
echo "   git add bucket/mcp-router.json"
echo "   git commit -m 'Add mcp-router manifest'"
echo "   git push"
echo ""
echo "3. Users can then install with:"
echo "   scoop bucket add mcp-router ${REPO_URL}"
echo "   scoop install mcp-router"
echo ""
