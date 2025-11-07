#!/usr/bin/env bash
set -euo pipefail

REPO="minio/mc"
TARGET_DATE="2025-06-15"
TARGET_TS=$(date -d "$TARGET_DATE" +%s)
PER_PAGE=100
PAGE=1

closest_tag=""
closest_diff=9999999999

while : ; do
    resp=$(curl -s "https://api.github.com/repos/${REPO}/releases?per_page=$PER_PAGE&page=$PAGE")
    tags=$(echo "$resp" | jq -r '.[] | "\(.tag_name) \(.published_at)"')

    # 没有 release 说明到最后一页
    if [[ -z "$tags" ]]; then
        break
    fi

    while read -r tag published_at; do
        ts=$(date -d "$published_at" +%s)
        diff=$(( ts > TARGET_TS ? ts - TARGET_TS : TARGET_TS - ts ))
        if (( diff < closest_diff )); then
            closest_diff=$diff
            closest_tag=$tag
        fi
    done <<< "$tags"

    # 检查是否还有下一页
    link=$(curl -sI "https://api.github.com/repos/${REPO}/releases?per_page=$PER_PAGE&page=$PAGE" | grep -i ^Link: || true)
    if [[ "$link" != *rel=\"next\"* ]]; then
        break
    fi

    PAGE=$((PAGE+1))
done

echo "✅ Closest release to $TARGET_DATE: $closest_tag"

