# Scoop Installation - Quick Start Guide

## 👥 For End Users

### Installation (Windows)

1. **First time only**: Add the Scoop bucket
   ```bash
   scoop bucket add mcp-router https://github.com/mcp-router/scoop-bucket
   ```

2. **Install MCP Router**
   ```bash
   scoop install mcp-router
   ```

3. **Run the application**
   ```bash
   mcp-router
   ```

### Keep Updated
```bash
scoop update mcp-router
```

### Uninstall
```bash
scoop uninstall mcp-router
```

---

## 👨‍💻 For Developers

### Setup Development Environment

```bash
# Clone repository
git clone https://github.com/mcp-router/mcp-router.git
cd mcp-router

# Install dependencies
pnpm install

# Checkout Scoop branch
git checkout feat/scoop-install-support
```

### Before Release

1. **Validate Scoop manifest**
   ```bash
   node tools/validate-scoop-manifest.js
   ```
   Expected output:
   ```
   ✓ Scoop manifest is valid
   Version: 0.6.1
   Description: A Unified MCP Server Management App
   ...
   ```

2. **Build Windows installer**
   ```bash
   cd apps/electron
   pnpm make
   # Output: apps/electron/out/make/
   ```

### Release Process

1. Update version in `package.json`
2. Create git tag: `git tag v0.6.2`
3. Push to GitHub
4. Create GitHub Release with the MSI file
5. **GitHub Actions automatically handles the rest!**
   - ✅ Downloads MSI
   - ✅ Calculates SHA256 hash
   - ✅ Updates `/scoop/mcp-router.json`
   - ✅ Commits changes

### Manual Manifest Update (if needed)

**Option 1: Update local manifest**
```bash
# Edit scoop/mcp-router.json directly
nano scoop/mcp-router.json
```

**Option 2: Update external Scoop bucket**

Bash (macOS/Linux):
```bash
./tools/update-scoop-bucket.sh "0.6.2" \
  "https://github.com/mcp-router/mcp-router/releases/download/v0.6.2/MCP-Router-0.6.2.msi" \
  "abc123def456..."
```

PowerShell (Windows):
```powershell
.\tools\Update-ScoopBucket.ps1 `
  -Version "0.6.2" `
  -MsiUrl "https://github.com/.../MCP-Router-0.6.2.msi" `
  -Sha256Hash "abc123def456..."
```

---

## 📁 File Structure

| File/Directory | Purpose |
|---|---|
| `scoop/mcp-router.json` | Scoop manifest (automatically updated) |
| `.github/workflows/scoop-update.yml` | Release automation |
| `tools/validate-scoop-manifest.js` | Manifest validator |
| `tools/update-scoop-bucket.sh` | External bucket updater (Bash) |
| `tools/Update-ScoopBucket.ps1` | External bucket updater (PowerShell) |
| `docs/scoop-setup.md` | Detailed technical docs |
| `SCOOP_IMPLEMENTATION.md` | Full implementation details |
| `apps/electron/forge.config.ts` | Build configuration (with signing support) |

---

## 🔧 Troubleshooting

| Problem | Solution |
|---|---|
| `scoop bucket add` fails | Check internet connection, ensure Git is installed |
| Manifest validation fails | Run `node tools/validate-scoop-manifest.js` |
| MSI not found in Release | Verify Windows build completed successfully |
| Installation fails | Run PowerShell as Administrator |
| Command not found after install | Restart terminal or add Scoop to PATH |

---

## 📚 More Information

- [Full Technical Documentation](docs/scoop-setup.md)
- [Implementation Summary](SCOOP_IMPLEMENTATION.md)
- [Scoop Official Documentation](https://scoop.sh/)
- [Scoop App Manifest Format](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifest-Format)

---

## ✅ Checklist for First Release

- [ ] Version number updated
- [ ] Local tests pass
- [ ] MSI built successfully
- [ ] GitHub Release created with MSI file
- [ ] GitHub Actions workflow completed successfully
- [ ] Manifest updated in `/scoop/mcp-router.json`
- [ ] Can install via: `scoop install mcp-router`
- [ ] Application launches correctly

---

**Branch**: `feat/scoop-install-support`  
**Status**: ✅ Ready for use
