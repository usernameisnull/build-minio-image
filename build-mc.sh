#!/usr/bin/env bash
set -euxo pipefail
CLONE_DIR='/tmp/mc'
RELEASE_VERSION_FILE='/tmp/mc.txt'
SUPPORTED_OSARCH="linux/amd64 linux/arm64"
BUILD_DIR='/tmp/build'
export MC_RELEASE='RELEASE'

function _clone() {
   if [[ $# -ne 1 ]]; then
       echo "Usage: $0 <minio release> (e.g.  RELEASE.2025-09-07T16-13-09Z)"
       exit 1
   fi
   rm -rf ${CLONE_DIR} ${RELEASE_VERSION_FILE}
   go run main.go -minio_release=${1}
   git clone --branch $(cat ${RELEASE_VERSION_FILE}) --depth 1 git@github.com:minio/mc.git ${CLONE_DIR}
}

function _build() {
	local osarch=$1
	IFS=/ read -r -a arr <<<"$osarch"
	local os="${arr[0]}"
	local arch="${arr[1]}"

	cd ${CLONE_DIR}
  LDFLAGS=$(go run buildscripts/gen-ldflags.go)
  echo "--ldflags ${LDFLAGS}"
  echo "Builds for OS/Arch: ${osarch}"
	CGO_ENABLED=0 GOOS=${os} GOARCH=${arch} go build -tags kqueue -trimpath --ldflags "${LDFLAGS}" -o ${BUILD_DIR}/mc-${os}-${arch}
}

function main() {
  _clone $1
  rm -rf ${BUILD_DIR}
	for each_osarch in ${SUPPORTED_OSARCH}; do
		_build "${each_osarch}"
	done
}

main "$@"


