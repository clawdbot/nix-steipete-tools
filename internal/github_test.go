package internal

import (
	"errors"
	"net"
	"net/http"
	"strings"
	"testing"
	"time"
)

type stubRoundTripper struct {
	fn func(*http.Request) (*http.Response, error)
}

func (s stubRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	return s.fn(req)
}

func TestHTTPClientHasTimeout(t *testing.T) {
	if HTTPClient == nil || HTTPClient.Timeout != 30*time.Second {
		t.Fatalf("HTTPClient.Timeout = %v, want 30s", HTTPClient.Timeout)
	}
}

func TestLatestReleaseUsesHTTPClient(t *testing.T) {
	oldClient := HTTPClient
	oldBase := GitHubAPIBase
	t.Cleanup(func() {
		HTTPClient = oldClient
		GitHubAPIBase = oldBase
	})

	GitHubAPIBase = "http://example.invalid"
	var sawURL string
	HTTPClient = &http.Client{
		Transport: stubRoundTripper{fn: func(req *http.Request) (*http.Response, error) {
			sawURL = req.URL.String()
			return nil, errors.New("sentinel-http-client")
		}},
	}

	_, err := LatestRelease("openclaw/gogcli")
	if err == nil || !strings.Contains(err.Error(), "sentinel-http-client") {
		t.Fatalf("LatestRelease error = %v", err)
	}
	if !strings.Contains(sawURL, "http://example.invalid/repos/openclaw/gogcli/releases/latest") {
		t.Fatalf("request URL = %q", sawURL)
	}
}

func TestLatestReleaseTimesOutOnSilentPeer(t *testing.T) {
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = ln.Close() })
	go func() {
		conn, acceptErr := ln.Accept()
		if acceptErr != nil {
			return
		}
		defer conn.Close()
		buf := make([]byte, 1)
		_, _ = conn.Read(buf)
	}()

	oldClient := HTTPClient
	oldBase := GitHubAPIBase
	t.Cleanup(func() {
		HTTPClient = oldClient
		GitHubAPIBase = oldBase
	})
	GitHubAPIBase = "http://" + ln.Addr().String()
	HTTPClient = &http.Client{Timeout: 200 * time.Millisecond}

	_, err = LatestRelease("openclaw/gogcli")
	if err == nil {
		t.Fatal("expected timeout error")
	}
}
