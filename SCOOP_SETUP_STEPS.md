# Scoop 安装支持 - 完整设置步骤

## 状态：✅ 已实现，需要创建 Scoop 桶仓库

MCP Router 已经实现了完整的 Scoop 安装支持。现在您需要创建 Scoop 桶仓库来使其正常工作。

---

## 🚀 快速开始（5 分钟）

### 第 1 步：创建 GitHub 仓库

1. 访问 https://github.com/new
2. 创建名为 `scoop-bucket` 的新仓库
3. 记下仓库 URL: `https://github.com/YOUR_USERNAME/scoop-bucket`

### 第 2 步：运行设置脚本

**在 macOS/Linux 上：**
```bash
./tools/setup-scoop-bucket.sh YOUR_USERNAME
```

**在 Windows 上：**
```powershell
.\tools\Setup-ScoopBucket.ps1 -Username YOUR_USERNAME
```

脚本会创建仓库结构并初始化 Git。

### 第 3 步：推送到 GitHub

```bash
cd scoop-bucket
git remote add origin https://github.com/YOUR_USERNAME/scoop-bucket.git
git branch -M main
git push -u origin main
```

### 第 4 步：添加 MCP Router 清单

```bash
cp ../mcp-router/scoop/mcp-router.json bucket/
git add bucket/mcp-router.json
git commit -m "Add mcp-router manifest v0.6.1"
git push
```

### 第 5 步：用户可以安装了

```bash
scoop bucket add mcp-router https://github.com/YOUR_USERNAME/scoop-bucket
scoop install mcp-router
```

---

## 📋 清单：实现了什么

### ✅ 核心实现

- [x] Scoop 清单文件 (`scoop/mcp-router.json`)
- [x] GitHub Actions 自动更新工作流
- [x] 清单验证脚本
- [x] 多语言文档（英、日、中）
- [x] 构建配置更新（代码签名支持）

### ✅ 工具和脚本

- [x] `tools/setup-scoop-bucket.sh` - Bash 初始化脚本
- [x] `tools/Setup-ScoopBucket.ps1` - PowerShell 初始化脚本
- [x] `tools/validate-scoop-manifest.js` - 清单验证
- [x] `tools/update-scoop-bucket.sh` - 清单更新脚本
- [x] `tools/Update-ScoopBucket.ps1` - PowerShell 更新脚本

### ✅ 文档

- [x] `docs/SCOOP_BUCKET_REQUIRED.md` - **必读：桶仓库设置指南**
- [x] `docs/SETUP_SCOOP_BUCKET.md` - 详细设置步骤
- [x] `docs/scoop-setup.md` - 技术文档
- [x] `SCOOP_IMPLEMENTATION.md` - 实现细节
- [x] `SCOOP_QUICKSTART.md` - 快速开始指南

---

## 📝 清单验证

检查清单是否有效：

```bash
node tools/validate-scoop-manifest.js
```

输出应该显示：
```
✓ Scoop manifest is valid
Version: 0.6.1
Description: A Unified MCP Server Management App
Download URL: https://github.com/mcp-router/mcp-router/releases/download/v0.6.1/MCP-Router-0.6.1.msi
SHA256: sha256:TO_BE_GENERATED
```

---

## 🔄 工作流程

### 开发者：发布新版本

1. 更新版本号
2. 在 Windows 上构建 MSI: `cd apps/electron && pnpm make`
3. 创建 GitHub Release 并上传 MSI
4. GitHub Actions 自动：
   - 计算 SHA256 哈希
   - 更新 `/scoop/mcp-router.json`
   - 提交到仓库

### 用户：首次安装

```bash
scoop bucket add mcp-router https://github.com/YOUR_USERNAME/scoop-bucket
scoop install mcp-router
```

### 用户：更新版本

```bash
scoop update mcp-router
```

---

## 🎯 后续步骤

1. **立即行动**
   - [ ] 在 GitHub 上创建 `scoop-bucket` 仓库
   - [ ] 运行 `./tools/setup-scoop-bucket.sh YOUR_USERNAME`
   - [ ] 推送到 GitHub
   - [ ] 复制 `scoop/mcp-router.json` 到 `bucket/` 目录
   - [ ] 提交并推送

2. **验证**
   - [ ] 运行清单验证: `node tools/validate-scoop-manifest.js`
   - [ ] 测试安装: `scoop install mcp-router`

3. **自动化**
   - [ ] 配置 GitHub Actions（可选）
   - [ ] 设置自动更新工作流（可选）

---

## 📚 详细文档

### 必读文档

- **[SCOOP_BUCKET_REQUIRED.md](docs/SCOOP_BUCKET_REQUIRED.md)** ⚠️
  - Scoop 桶仓库的必读指南
  - 快速 5 分钟设置

### 完整指南

- **[SETUP_SCOOP_BUCKET.md](docs/SETUP_SCOOP_BUCKET.md)**
  - 完整的分步说明
  - 手动和自动化选项
  - 故障排除

- **[scoop-setup.md](docs/scoop-setup.md)**
  - 技术细节
  - 清单格式说明
  - 自动化流程

### 快速参考

- **[SCOOP_QUICKSTART.md](SCOOP_QUICKSTART.md)**
  - 用户和开发者指南
  - 常见任务
  - 故障排除

### 实现细节

- **[SCOOP_IMPLEMENTATION.md](SCOOP_IMPLEMENTATION.md)**
  - 完整的实现概述
  - 文件和组件说明
  - 架构设计

---

## 🔧 故障排除

### 错误：`doesn't look like a valid git repository`

**问题**: Scoop 找不到仓库

**原因**: `scoop-bucket` 仓库还不存在

**解决方案**:
```bash
# 1. 在 GitHub 上创建仓库
# 2. 运行设置脚本
./tools/setup-scoop-bucket.sh YOUR_USERNAME
# 3. 推送到 GitHub
```

### 错误：`Repository not found`

**问题**: Git 无法连接到仓库

**原因**: 仓库 URL 错误或不存在

**解决方案**:
```bash
# 检查 URL
git ls-remote https://github.com/YOUR_USERNAME/scoop-bucket

# 验证仓库是公开的
# 访问 https://github.com/YOUR_USERNAME/scoop-bucket
```

---

## 🎓 学习资源

- [Scoop 官方文档](https://scoop.sh/)
- [Scoop 桶指南](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
- [应用清单格式](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifest-Format)

---

## 📊 当前状态

| 组件 | 状态 | 说明 |
|------|------|------|
| 清单文件 | ✅ 完成 | `/scoop/mcp-router.json` |
| 自动化工作流 | ✅ 完成 | `.github/workflows/scoop-update.yml` |
| 验证工具 | ✅ 完成 | `tools/validate-scoop-manifest.js` |
| 文档 | ✅ 完成 | 4 份详细文档 |
| 脚本工具 | ✅ 完成 | Bash + PowerShell |
| Scoop 桶仓库 | ⏳ 需要创建 | 用户需要在 GitHub 上创建 |

---

## ✨ 总结

MCP Router 的 Scoop 安装支持已完全实现。您只需要：

1. 创建 GitHub 仓库 `scoop-bucket`
2. 运行一个设置脚本（5 分钟）
3. 推送到 GitHub

**之后**，用户可以用一个简单的命令安装：
```bash
scoop install mcp-router
```

---

**准备好了吗？** 开始：[SCOOP_BUCKET_REQUIRED.md](docs/SCOOP_BUCKET_REQUIRED.md)
