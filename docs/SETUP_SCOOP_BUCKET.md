# 设置 Scoop 桶仓库指南

本文档说明如何创建和配置您的 Scoop 桶仓库，使用户能够通过 Scoop 安装 MCP Router。

## 前置要求

- GitHub 账户
- Git 命令行工具
- 基础 Git 知识

## 步骤 1：在 GitHub 上创建仓库

1. 访问 https://github.com/new
2. 填写信息：
   - **Repository name**: `scoop-bucket`
   - **Description**: `A Scoop bucket for MCP Router`
   - **Visibility**: Public
   - **Initialize with**: 不勾选（我们会用脚本初始化）
3. 点击 "Create repository"

结果仓库 URL: `https://github.com/YOUR_USERNAME/scoop-bucket`

## 步骤 2：使用脚本初始化本地仓库

### 选项 A：快速设置（推荐）

```bash
# 运行设置脚本
./tools/setup-scoop-bucket.sh llyzot

# 或指定位置
./tools/setup-scoop-bucket.sh llyzot scoop-bucket /tmp
```

脚本会自动创建：
- 目录结构
- README.md
- .gitignore
- Git 初始化

### 选项 B：手动设置

```bash
# 创建目录
mkdir -p scoop-bucket/bucket
cd scoop-bucket

# 初始化 Git
git init
git config user.name "Your Name"
git config user.email "your.email@example.com"

# 创建基本文件
echo "# Scoop Bucket" > README.md
echo ".DS_Store" > .gitignore

# 创建初始提交
git add .
git commit -m "Initial commit: Scoop bucket structure"
```

## 步骤 3：连接到 GitHub

```bash
cd scoop-bucket
git remote add origin https://github.com/YOUR_USERNAME/scoop-bucket.git
git branch -M main
git push -u origin main
```

## 步骤 4：添加 MCP Router 清单

### 从项目复制清单

```bash
# 从 MCP Router 项目复制清单
cp ../mcp-router/scoop/mcp-router.json bucket/

# 验证清单
../mcp-router/tools/validate-scoop-manifest.js

# 提交
git add bucket/mcp-router.json
git commit -m "Add mcp-router manifest v0.6.1"
git push
```

## 步骤 5：用户安装

用户现在可以使用以下命令安装：

```bash
scoop bucket add mcp-router https://github.com/YOUR_USERNAME/scoop-bucket
scoop install mcp-router
```

## 自动更新流程

GitHub Actions 工作流 `.github/workflows/scoop-update.yml` 会在每次发布时：

1. 从 GitHub Release 下载最新的 MSI 文件
2. 计算 SHA256 哈希值
3. 更新本地 `/scoop/mcp-router.json`
4. 提交更改

您需要：

1. **启用 GitHub Actions** 在您的 scoop-bucket 仓库
2. **配置 GitHub Token**（如果需要推送访问权限）
3. **验证清单**在每次发布后被正确更新

### 配置 GitHub Actions 权限

1. 进入 Settings → Actions → General
2. 确保 "Allow all actions and reusable workflows" 被选中
3. 在 "Workflow permissions" 中选择 "Read and write permissions"

## 仓库结构示例

```
scoop-bucket/
├── .git/                          # Git 历史
├── .github/
│   └── workflows/                 # 工作流（如果需要）
├── .gitignore                     # Git 忽略文件
├── README.md                      # 文档
└── bucket/
    ├── README.md                  # 桶说明
    └── mcp-router.json           # 应用清单
```

## 清单文件结构

`bucket/mcp-router.json` 包含：

```json
{
  "version": "0.6.1",
  "description": "A Unified MCP Server Management App",
  "homepage": "https://github.com/mcp-router/mcp-router",
  "license": "Sustainable Use License",
  "architecture": {
    "64bit": {
      "url": "https://github.com/mcp-router/mcp-router/releases/download/v0.6.1/MCP-Router-0.6.1.msi",
      "hash": "sha256:ACTUAL_HASH"
    }
  },
  "installer": {...},
  "uninstaller": {...},
  "shortcuts": [...]
}
```

## 验证清单

运行验证脚本：

```bash
node tools/validate-scoop-manifest.js
```

应该输出：

```
✓ Scoop manifest is valid
Version: 0.6.1
Description: A Unified MCP Server Management App
Download URL: https://github.com/mcp-router/mcp-router/releases/download/v0.6.1/MCP-Router-0.6.1.msi
SHA256: sha256:abc123...
```

## 故障排除

### 问题：`doesn't look like a valid git repository`

**原因**: 仓库不存在或 URL 错误

**解决方案**:
```bash
# 验证仓库存在
git ls-remote https://github.com/YOUR_USERNAME/scoop-bucket

# 检查 URL 格式
# 应该是: https://github.com/YOUR_USERNAME/scoop-bucket
```

### 问题：`permission denied`

**原因**: 需要 GitHub 认证

**解决方案**:
```bash
# 使用 SSH（如果配置了）
git remote set-url origin git@github.com:YOUR_USERNAME/scoop-bucket.git

# 或使用 Personal Access Token
git remote set-url origin https://YOUR_TOKEN@github.com/YOUR_USERNAME/scoop-bucket.git
```

### 问题：清单验证失败

**原因**: JSON 格式或字段错误

**解决方案**:
```bash
# 验证 JSON 格式
jq . bucket/mcp-router.json

# 检查必需字段
node tools/validate-scoop-manifest.js

# 查看 docs/scoop-setup.md 了解清单格式
```

## 参考资源

- [Scoop 官方文档](https://scoop.sh/)
- [Scoop 桶指南](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
- [应用清单格式](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifest-Format)
- [MCP Router Scoop 实现](../SCOOP_IMPLEMENTATION.md)

## 最佳实践

1. ✅ 保持清单文件最新
2. ✅ 验证 SHA256 哈希值准确
3. ✅ 编写清晰的提交信息
4. ✅ 定期测试安装流程
5. ✅ 监控 GitHub Actions 执行

## 下一步

1. 创建 GitHub 仓库
2. 运行设置脚本
3. 推送到 GitHub
4. 添加 mcp-router.json 清单
5. 测试用户安装流程

---

**需要帮助?** 查看 [SCOOP_QUICKSTART.md](../SCOOP_QUICKSTART.md)
