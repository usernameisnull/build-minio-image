#!/usr/bin/env bash
set -euo pipefail
CLONE_DIR='/tmp/mc'
RELEASE_FILE='/tmp/mc.txt'
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <minio release> (e.g.  RELEASE.2025-09-07T16-13-09Z)"
    exit 1
fi
go run main.go -minio_release=${1}
git clone --branch $(cat ${RELEASE_FILE}) --depth 1 git@github.com:minio/mc.git ${CLONE_DIR}
cd ${CLONE_DIR}
go run buildscripts/gen-ldflags.go



