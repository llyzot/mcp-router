# Scoop Installation Support - Implementation Summary

## 概述

本项目已完全实现 Scoop 包管理器对 MCP Router 的安装支持。此文档总结了所有实现的内容。

## 实现的组件

### 1. Scoop 清单文件
- **文件**: `/scoop/mcp-router.json`
- **功能**: 定义 Windows MSI 安装程序的元数据
- **包含**: 版本、描述、URL、SHA256 哈希值、安装/卸载脚本

### 2. GitHub Actions 自动化
- **文件**: `.github/workflows/scoop-update.yml`
- **触发**: 在 GitHub Release 发布时自动执行
- **功能**:
  - 从 Release 获取最新的 MSI 安装程序
  - 自动计算 SHA256 哈希值
  - 更新 `/scoop/mcp-router.json` 清单
  - 自动提交变更到仓库

### 3. 辅助脚本
- **`tools/validate-scoop-manifest.js`**: 验证清单文件有效性
- **`tools/update-scoop-bucket.sh`**: Bash 脚本，用于更新外部 Scoop 桶
- **`tools/Update-ScoopBucket.ps1`**: PowerShell 脚本，用于 Windows 环境

### 4. 文档
- **`docs/scoop-setup.md`**: 详细的技术文档和设置指南
- **`SCOOP_IMPLEMENTATION.md`**: 本文档

### 5. 构建配置
- **文件**: `apps/electron/forge.config.ts`
- **修改**: 添加对代码签名证书环境变量的支持
  - `SIGNING_CERT_PATH`: 证书文件路径
  - `SIGNING_CERT_PASSWORD`: 证书密码

## 用户使用流程

### 安装步骤

```bash
# 1. 添加 Scoop 桶（一次性）
scoop bucket add mcp-router https://github.com/llyzot/scoop-bucket

# 2. 安装 MCP Router
scoop install mcp-router

# 3. 运行应用
mcp-router
```

### 更新步骤

```bash
scoop update mcp-router
```

## 开发者工作流

### 发布新版本

1. **本地开发**
   ```bash
   git checkout feat/scoop-install-support
   # 进行代码修改和测试
   ```

2. **更新版本号**
   - 更新 `package.json` 中的版本号

3. **构建 MSI 安装程序**
   ```bash
   cd apps/electron
   pnpm make
   ```

4. **创建 GitHub Release**
   - 上传 MSI 文件到 Release
   - GitHub Actions 自动更新清单

5. **验证清单**
   ```bash
   node tools/validate-scoop-manifest.js
   ```

## 自动化工作流

```
Developer Creates Release
    ↓
GitHub Actions Triggered
    ↓
Extract MSI from Release
    ↓
Calculate SHA256 Hash
    ↓
Update scoop/mcp-router.json
    ↓
Commit & Push to Repository
    ↓
✅ Users Can Install via Scoop
```

## 文件结构

```
project-root/
├── scoop/
│   └── mcp-router.json           # Scoop 清单
├── .github/workflows/
│   └── scoop-update.yml          # GitHub Actions 工作流
├── tools/
│   ├── validate-scoop-manifest.js # 验证脚本
│   ├── update-scoop-bucket.sh    # Bash 更新脚本
│   └── Update-ScoopBucket.ps1    # PowerShell 更新脚本
├── docs/
│   └── scoop-setup.md            # 详细文档
└── apps/electron/
    └── forge.config.ts           # Electron Forge 配置（已更新）
```

## 环境变量配置

为了支持代码签名，需要配置以下环境变量（可选，用于正式发布）：

```bash
export SIGNING_CERT_PATH="/path/to/certificate.p12"
export SIGNING_CERT_PASSWORD="certificate-password"
```

## 验证

### 清单验证
```bash
node tools/validate-scoop-manifest.js
```

### 本地安装测试（需要 Windows）
```bash
scoop install mcp-router
```

## 外部 Scoop 桶

用户通过以下方式安装：

```bash
scoop bucket add mcp-router https://github.com/llyzot/scoop-bucket
```

该桶的 `bucket/mcp-router.json` 由 GitHub Actions 工作流自动更新。

## 故障排除

### 清单验证失败
- 检查 `/scoop/mcp-router.json` 的 JSON 格式
- 确保所有必需字段都存在
- 运行 `node tools/validate-scoop-manifest.js`

### MSI 文件未找到
- 确保在 Release 中上传了 MSI 文件
- 检查 GitHub Actions 日志中的 `scoop-update.yml`

### 哈希值不匹配
- 清单中的 SHA256 哈希应与实际下载的 MSI 文件匹配
- 如需手动计算（Windows）：
  ```powershell
  (Get-FileHash "MCP-Router-0.6.1.msi" -Algorithm SHA256).Hash
  ```

## 下一步

1. **创建/配置外部 Scoop 桶**（如果还未创建）
   - 仓库：`https://github.com/llyzot/scoop-bucket`
   - 结构：`bucket/mcp-router.json`

2. **发布第一个版本**
   - 构建 Windows MSI
   - 创建 GitHub Release
   - 验证自动化工作

3. **测试用户安装流程**
   - 验证 Scoop 安装正常工作
   - 收集反馈

## 相关文档

- [Scoop 官方文档](https://scoop.sh/)
- [Scoop 清单格式](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifest-Format)
- [Scoop 桶指南](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
- 本项目: `docs/scoop-setup.md`

---

**实现状态**: ✅ 完成
**分支**: `feat/scoop-install-support`
**最后更新**: 2024年11月18日
