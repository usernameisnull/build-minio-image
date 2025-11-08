
function _build() {
	local component=$1
	IFS=/ read -r -a arr <<<"$osarch"
	local os="${arr[0]}"
	local arch="${arr[1]}"

	cd ${CLONE_DIR}
  LDFLAGS=$(go run buildscripts/gen-ldflags.go)
  echo "--ldflags ${LDFLAGS}"
  echo "Builds for OS/Arch: ${osarch}"
  mkdir -p "${BUILD_DIR}"
	CGO_ENABLED=0 go build -tags kqueue -trimpath --ldflags "${LDFLAGS}" -o ${BUILD_DIR}/${component}
	chmod +x ${BUILD_DIR}/${component}
}

# $1: the minio tag
# $2: mc or minio
function main() {
  _clone ${1}
  rm -rf ${BUILD_DIR}
  _build ${2}
}