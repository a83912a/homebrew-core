class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2178f66a776c88c46d0b1913be4901f59867db19a351201328fcad1abe5f1347"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ec62c97c2d7b6f72b391e310d9e1d0943d189aa1cd1c123c2b2f8af2b545ff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8adaa248fb06359347e0a226f6232b562cee6828b093b0c431708a26d9f26e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f349cdb736656c7dce734b40ba5ddea1e9b8d32452774cde1027bcd0996636f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6d07bea1bb599eb99b08345aab528237d97834a6254444291ee85ea6f916ff9"
    sha256 cellar: :any_skip_relocation, ventura:        "bf3c5f42d92ebeef36c38885f359af905bdc16a205f9b944febde2980a16b033"
    sha256 cellar: :any_skip_relocation, monterey:       "35f5ac450e27c913cea22cef5212427bab66e764a5e622788a3c7b829a2fbc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba2a98bb72af407674b5d60cda47a6a584b6a0f1272a8955c192a16d172e3df"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "crates/noseyparker-cli")
    mv bin/"noseyparker-cli", bin/"noseyparker"

    generate_completions_from_executable(bin/"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noseyparker -V")

    output = shell_output(bin/"noseyparker scan --git-url https://github.com/Homebrew/brew")
    assert_match "0/0 new matches", output
  end
end
