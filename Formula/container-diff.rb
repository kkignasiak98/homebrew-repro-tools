class ContainerDiff < Formula
  desc "Tool: Container-diff: Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ba369effbe0d9f556cbcdadd5882eeb6346a105c11e5f07ffccb7e834cadefe6"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"container-diff", "--help"
  end
end
