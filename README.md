# Build MinIO Image Automatically

English | [中文](README_CN.md)

## 🧭 Overview

Since the official **MinIO** project no longer publishes Docker images(the last published was RELEASE.2025-09-07T16-13-09Z), this project automatically builds and publishes updated **MinIO images** based on the releases from the official MinIO repository.

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


