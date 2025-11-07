package main

import (
	"errors"
	"flag"
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"

	"resty.dev/v3"
)

const (
	timeFormat         = "2006-01-02T15:04:05Z"
	minioReleasePrefix = "RELEASE."
	initPage           = 1
	maxPerPage         = 100
	tarbarFileName     = "/tmp/mc.tar.gz"
)

var (
	// https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#list-releases
	// max page is 100
	// Only the first 1000 results are available.
	repoURL                 = "https://api.github.com/repos/%s/releases?per_page=%d&page=%d"
	maybeTheLastError error = errors.New("maybe the last page, return code: 422")
)

type GithubRelease struct {
	PublishedAt string `json:"published_at"`
	TarballURL  string `json:"tarball_url"`
}

func main() {
	var minioRelease = flag.String("minio_release", "", "Specify the MinIO release version or tag")
	flag.Parse()
	if *minioRelease != "" {
		log.Printf("MinIO release version: %s\n", *minioRelease)
	} else {
		log.Println("MinIO release version not specified")
	}
	// https://api.github.com/repos/${REPO}/releases?per_page=${PER_PAGE}&page=${PAGE}
	client := resty.New()
	defer client.Close()
	releaseURL, err := getReleaseByDate(client, "minio/mc", convertReleaseStr(*minioRelease))
	if err != nil {
		log.Fatalf(err.Error())
	}
	log.Printf("found the release url: %s", releaseURL)
	if err = downloadTarball(client, releaseURL); err != nil {
		log.Fatalf(err.Error())
	}
	log.Printf("download mc source success")
}

func getReleaseByDate(client *resty.Client, repo, dateStr string) (string, error) {
	inputDateUnix, err := parseDateStr(dateStr)
	if err != nil {
		log.Fatalf("invalid input date string format: '%s', expect format: '%s'", dateStr, timeFormat)
	}
	releases := []GithubRelease{}
	startPage := initPage
	for {
		res, err := client.R().
			SetResult(&releases).
			EnableTrace().
			SetHeader("Accept", "application/vnd.github.v3+json").
			Get(fmt.Sprintf(repoURL, repo, maxPerPage, startPage))
		if err != nil {
			return "", err
		}
		resCode := res.StatusCode()
		if resCode == http.StatusUnprocessableEntity {
			return "", maybeTheLastError
		}
		if resCode != http.StatusOK {
			return "", fmt.Errorf("status code is not %d", resCode)
		}
		for _, item := range releases {
			tmp, err := parseDateStr(item.PublishedAt)
			if err != nil {
				log.Printf("'%s' parse error: %s", item.PublishedAt, err)
				continue
			}
			// The first one that is earlier than the input date is the release we need.
			if tmp <= inputDateUnix {
				return item.TarballURL, nil
			}
		}
		startPage += maxPerPage
	}
	return "", nil
}

func parseDateStr(dateStr string) (int64, error) {
	t, err := time.Parse(timeFormat, dateStr)
	if err != nil {
		return -1, err
	}
	return t.Unix(), nil
}

func convertReleaseStr(s string) string {
	res := strings.TrimPrefix(s, minioReleasePrefix)
	parts := strings.SplitN(res, "T", 2)
	if len(parts) != 2 {
		log.Fatalf("invalid input date minio release: '%s', expect format: '%s', "+
			"check the minio release page: https://github.com/minio/minio/releases",
			s, minioReleasePrefix+"."+timeFormat)
	}
	datePart := parts[0]
	timePart := parts[1]
	// Replace the '-' in timePart with ':'.
	timePart = strings.ReplaceAll(timePart, "-", ":")
	return datePart + "T" + timePart
}

func downloadTarball(client *resty.Client, url string) error {
	res, err := client.R().
		SetSaveResponse(true).
		SetOutputFileName(tarbarFileName).
		Get(url)
	if err != nil {
		return err
	}
	if res.StatusCode() != http.StatusOK {
		return fmt.Errorf("download tarball, status code is not %d", res.StatusCode())
	}
	return nil
}
