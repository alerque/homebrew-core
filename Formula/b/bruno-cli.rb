class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-1.38.1.tgz"
  sha256 "85df13ae0a5944b02d20da7a8dd0ed72de41b448befd0a880a0a8a806bd9a285"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9629275dcd9ed700d7959933b79765dd77e71a14793b252341733566b7cf255"
    sha256 cellar: :any_skip_relocation, ventura:       "e9629275dcd9ed700d7959933b79765dd77e71a14793b252341733566b7cf255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9a96affa1cad1d328755860183241ce6bf60cd758c4207c5c906ad8541beef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end
