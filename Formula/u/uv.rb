class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.2.37.tar.gz"
  sha256 "158ad67b27c9aca0deac28ded88e9047ff338564f23a104de4dfcef21cd3a074"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d0ae557680f768ed7c9cbe56c2e05beb2f9b118242e6c40d887ba186e49faaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d384ace27ed580b2b78ebae21cd3683d36cbd93adcf416c0f6400cbee919b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b692861a84ed51b4a87aa163f90c24f60d812367982bc6f135fbce0870412a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6cff286049e8c553c4825ef6a85461e34173b977d6d19d3de1ae98a39882285"
    sha256 cellar: :any_skip_relocation, ventura:        "6523ffafc8bc38989b92e68445569fd59995e63a36f8f6dcf62bde573263726c"
    sha256 cellar: :any_skip_relocation, monterey:       "96ef71f5bf6a85410d80066a3d131133757ffcf909e099cf083eeed4443ff88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da3e459a7a9d42794c1f9963a33d91f1865470bf64f80bd649e75ab5534d9b8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "xz"

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
