module minio-release

// The Go version specified here should be consistent with the first base image version in Dockerfile.release.
go 1.24

require (
	github.com/samber/lo v1.52.0
	resty.dev/v3 v3.0.0-beta.3
)

require (
	golang.org/x/net v0.33.0 // indirect
	golang.org/x/text v0.22.0 // indirect
)
