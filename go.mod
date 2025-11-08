module downlaod-release

// 这里的go版本要与Dockerfile.release的第一个镜像版本相匹配
go 1.24

require resty.dev/v3 v3.0.0-beta.3

require golang.org/x/net v0.33.0 // indirect
