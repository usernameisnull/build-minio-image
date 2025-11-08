#!/usr/bin/env bash
set -euxo pipefail
bash build-mc.sh
bash build-minio.sh
cp Dockerfile.release /tmp/minio/Dockerfile.release
