# Scoop 桶仓库 - 必读指南

## ⚠️ 重要信息

为了使用 Scoop 安装 MCP Router，您必须先创建一个 **Scoop 桶仓库**。

Scoop 不能直接从单个文件安装应用 - 它需要一个真实的 Git 仓库作为"桶"。

## 快速开始（5 分钟）

### 1️⃣ 在 GitHub 上创建仓库

访问 https://github.com/new 并创建：
- **名称**: `scoop-bucket`
- **描述**: `Scoop bucket for MCP Router`
- **可见性**: Public

记住仓库 URL: `https://github.com/YOUR_USERNAME/scoop-bucket`

### 2️⃣ 使用脚本初始化

**在 macOS/Linux 上:**

```bash
./tools/setup-scoop-bucket.sh YOUR_USERNAME
```

**在 Windows 上:**

```powershell
.\tools\Setup-ScoopBucket.ps1 -Username YOUR_USERNAME
```

脚本会自动创建目录结构并初始化 Git。

### 3️⃣ 推送到 GitHub

```bash
cd scoop-bucket
git remote add origin https://github.com/YOUR_USERNAME/scoop-bucket.git
git branch -M main
git push -u origin main
```

### 4️⃣ 添加 MCP Router 清单

```bash
cp ../mcp-router/scoop/mcp-router.json bucket/
git add bucket/mcp-router.json
git commit -m "Add mcp-router manifest"
git push
```

### 5️⃣ 用户现在可以安装了

```bash
scoop bucket add mcp-router https://github.com/YOUR_USERNAME/scoop-bucket
scoop install mcp-router
```

## 为什么需要单独的仓库？

这是 Scoop 的设计要求：

✅ **Scoop 桶** = Git 仓库  
✅ **清单文件** = 仓库中的 JSON 文件  
✅ **用户** = 添加桶后可以安装任何清单中的应用  

## 仓库结构

```
scoop-bucket/
├── .git/                 # Git 历史
├── .gitignore            # Git 忽略规则
├── README.md             # 文档
└── bucket/
    ├── README.md         # 桶说明
    └── mcp-router.json   # MCP Router 清单
```

## 自动更新

一旦桶仓库创建好，GitHub Actions 工作流会：

1. **监听** MCP Router 项目的 Release
2. **获取** 最新的 MSI 安装程序
3. **计算** SHA256 哈希
4. **更新** `/scoop/mcp-router.json`
5. **推送** 到您的桶仓库

这样用户总是能获得最新版本。

## 完整指南

详细说明请查看: [`SETUP_SCOOP_BUCKET.md`](SETUP_SCOOP_BUCKET.md)

该指南包含：
- ✅ 完整的分步说明
- ✅ 手动设置选项
- ✅ 故障排除
- ✅ 最佳实践

## 遇到问题？

### 错误：`doesn't look like a valid git repository`

这意味着 GitHub 上还没有创建仓库。请先：

1. 访问 https://github.com/new
2. 创建名为 `scoop-bucket` 的新仓库
3. 复制仓库 URL
4. 运行设置脚本

### 错误：`Repository not found`

检查：
- ✓ 仓库名称拼写正确
- ✓ URL 格式正确: `https://github.com/USERNAME/scoop-bucket`
- ✓ 仓库是 Public
- ✓ 已推送到 GitHub

### 需要帮助？

查看完整指南: [`SETUP_SCOOP_BUCKET.md`](SETUP_SCOOP_BUCKET.md)

---

## 总结

1. 创建 GitHub 仓库 `scoop-bucket`
2. 运行 `./tools/setup-scoop-bucket.sh YOUR_USERNAME`
3. 推送到 GitHub
4. 复制 `scoop/mcp-router.json` 到 `bucket/` 目录
5. 提交并推送
6. 完成！用户可以安装了

**预计时间**: 5-10 分钟
