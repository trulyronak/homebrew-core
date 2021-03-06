class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/Kong/kuma.git",
      :tag      => "0.4.0",
      :revision => "a37aaadf84e97fa9e5135c31353b51ba6a2245f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "eff8edfec8b9f41c9488bf4bf34518af27b5272ccf25935e94e14716fb09e055" => :catalina
    sha256 "2fa66e54b56d29ed3d2ded1d486e5107bb03b95f1b819a366e8ee0207d8a7388" => :mojave
    sha256 "e0022bc88bbfd96c5897e99f4f73866f6c3580a99e0ade811d3aeb3f177312fa" => :high_sierra
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    outpath = srcpath/"build/artifacts-darwin-amd64/kumactl"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl"
      prefix.install_metafiles
      bin.install outpath/"kumactl"
    end
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config"
    assert_match "Error: YAML contains invalid resource: Name field cannot be empty",
    shell_output("#{bin}/kumactl apply -f config 2>&1", 1)
  end
end
