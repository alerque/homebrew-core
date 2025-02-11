class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "96c167a96fb62f4177b1b3159a9e00acbbe0bb1bafeb68a52da7341e6487e99d"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69c78c8d188ce9f0187dd7b30ae7acb4a679fb73cc1d958401a8522e660796f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69c78c8d188ce9f0187dd7b30ae7acb4a679fb73cc1d958401a8522e660796f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f69c78c8d188ce9f0187dd7b30ae7acb4a679fb73cc1d958401a8522e660796f"
    sha256 cellar: :any_skip_relocation, sonoma:        "77af6b0df353a12ebfbfc1022a78f47fa7e866114e24a77905a43d7dd839eda1"
    sha256 cellar: :any_skip_relocation, ventura:       "77af6b0df353a12ebfbfc1022a78f47fa7e866114e24a77905a43d7dd839eda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb29f7da2a74dcd0508ed9f961bcf75fd69a163436762fe20617d63920067ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
