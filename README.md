# Build MinIO Image Automatically

[🇨🇳 中文版说明](#中文说明)

---

## 🧭 Overview

Since the official **MinIO** project no longer publishes Docker images, this project automatically builds and publishes updated **MinIO images** based on the releases from the official MinIO repository.

The workflow monitors MinIO’s [release page](https://github.com/minio/minio/releases), detects new tags, and builds corresponding Docker images.

In addition, the image includes the **`mc` (MinIO Client)** command-line tool.  
Because there is currently no official mapping between MinIO and `mc` versions, this project follows this rule:

> The `mc` version included is the first version **released after** the corresponding MinIO release.

All built images are available in this repository’s **Packages** section.

---

## 📦 Generated Images

You can view the published images under the [Packages](../../packages) tab of this repository.

---

## ⚙️ How It Works

1. Detects new MinIO release tags via GitHub API.
2. Determines the appropriate `mc` version following the rule above.
3. Builds and pushes the image to GitHub Container Registry (GHCR).
4. Tags follow the MinIO release tag (e.g. `RELEASE.2025-05-24T09-08-49Z`).

---

## 🔗 Related Resources

- [MinIO GitHub Repository](https://github.com/minio/minio)
- [MinIO Client (`mc`)](https://github.com/minio/mc)
- [GitHub Container Registry Docs](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

# 中文说明

[⬆️ Back to English](#build-minio-image-automatically)

---

## 🧭 项目简介

由于官方 **MinIO** 项目已不再发布 Docker 镜像，本项目用于**自动构建并发布 MinIO 镜像**，以追踪官方 MinIO 仓库的 Release 更新。

程序会监控 [MinIO 的发布页面](https://github.com/minio/minio/releases)，检测新的 tag 并自动构建对应镜像。

此外，镜像中还包含 **`mc` (MinIO Client)** 命令行工具。  
由于目前尚无官方提供的 `mc` 与 MinIO 版本对应关系，本项目采用如下策略：

> 镜像中包含的 `mc` 版本为：**在对应 MinIO 发布之后最接近且晚于该发布的第一个版本。**

所有构建完成的镜像可以在本仓库的 **Packages** 页面中查看。

---

## 📦 镜像查看

请前往本仓库的 [Packages](../../packages) 页面查看所有已发布的镜像。

---

## ⚙️ 工作原理

1. 使用 GitHub API 检测新的 MinIO Release 标签；
2. 根据上述规则选择合适的 `mc` 版本；
3. 构建镜像并推送至 GitHub Container Registry (GHCR)；
4. 镜像标签与 MinIO 发布版本一致（如 `RELEASE.2025-05-24T09-08-49Z`）。

---

## 🔗 相关链接

- [MinIO 官方仓库](https://github.com/minio/minio)
- [MinIO 客户端 `mc`](https://github.com/minio/mc)
- [GitHub 容器仓库文档](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
