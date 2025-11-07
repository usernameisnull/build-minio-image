SUPPORTED_OSARCH="linux/amd64 linux/arm64"

function _build() {
	local osarch=$1
	local component=$2
	IFS=/ read -r -a arr <<<"$osarch"
	local os="${arr[0]}"
	local arch="${arr[1]}"

	cd ${CLONE_DIR}
  LDFLAGS=$(go run buildscripts/gen-ldflags.go)
  echo "--ldflags ${LDFLAGS}"
  echo "Builds for OS/Arch: ${osarch}"
  mkdir -p "${BUILD_DIR}"
	CGO_ENABLED=0 GOOS=${os} GOARCH=${arch} go build -tags kqueue -trimpath --ldflags "${LDFLAGS}" -o ${BUILD_DIR}/${component}-${os}-${arch}
}

# $1: the minio tag
# $2: mc or minio
function main() {
  _clone ${1}
  rm -rf ${BUILD_DIR}
	for each_osarch in ${SUPPORTED_OSARCH}; do
		_build "${each_osarch}" ${2}
	done
}