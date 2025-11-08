#!/usr/bin/env bash
# DOCKER_BUILDKIT=0, 可以看到输出
# 如果不需要cache, 在最后加上 --no-cache
DOCKER_BUILDKIT=0 docker build --build-arg MINIO_VERSION=RELEASE.2025-09-07T16-13-09Z -f Dockerfile.release -t xxx . --no-cache