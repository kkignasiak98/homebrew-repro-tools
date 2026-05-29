class ContainerDiffoscope < Formula
  include Language::Python::Virtualenv

  desc "Elegant Container filesystem comparison"
  homepage "https://github.com/kkignasiak98/container-diffoscope"
  url "https://github.com/kkignasiak98/container-diffoscope/archive/refs/tags/0.1.0.tar.gz"
  sha256 "107fe5768f1023fb1f3474fe1c54d8cadf45e34645470d6893c1a84ff4a5f9c1"
  license ""

  depends_on "diffoscope"
  depends_on "python@3.14"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/67/a5/756f2e6bc81a7dd79aa3c625dd01b74cabc4516628cace2caaec09ca6ff2/typer-0.26.2.tar.gz"
    sha256 "9b4f19e08fcc9427a822d1ef467b1fe76737a2f65c7926bdeba2337d73569b68"
  end

  # polars ships as a pre-built binary wheel (Rust extension). Building it from
  # an sdist would require a full Rust/Cargo toolchain, so we install the
  # platform-specific wheel directly instead.
  resource "polars" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://files.pythonhosted.org/packages/f8/15/1094099a1b9cb4fbff58cd8ed3af8964f4d22a5b682ea0b7bb72bf4bc3d9/polars-1.33.1-cp39-abi3-macosx_11_0_arm64.whl"
        sha256 "29200b89c9a461e6f06fc1660bc9c848407640ee30fe0e5ef4947cfd49d55337"
      else
        url "https://files.pythonhosted.org/packages/19/79/c51e7e1d707d8359bcb76e543a8315b7ae14069ecf5e75262a0ecb32e044/polars-1.33.1-cp39-abi3-macosx_10_12_x86_64.whl"
        sha256 "3881c444b0f14778ba94232f077a709d435977879c1b7d7bd566b55bd1830bb5"
      end
    end
    on_linux do
      if Hardware::CPU.arm?
        url "https://files.pythonhosted.org/packages/7a/26/4c5da9f42fa067b2302fe62bcbf91faac5506c6513d910fae9548fc78d65/polars-1.33.1-cp39-abi3-manylinux_2_24_aarch64.whl"
        sha256 "094a37d06789286649f654f229ec4efb9376630645ba8963b70cb9c0b008b3e1"
      else
        url "https://files.pythonhosted.org/packages/8d/b9/9ac769e4d8e8f22b0f2e974914a63dd14dec1340cd23093de40f0d67d73b/polars-1.33.1-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
        sha256 "444940646e76342abaa47f126c70e3e40b56e8e02a9e89e5c5d1c24b086db58a"
      end
    end
  end

  def install
    # Install everything except polars from source via the normal flow.
    venv = virtualenv_install_with_resources(without: "polars")

    # polars is distributed only as a pre-built binary wheel (Rust extension).
    # Homebrew's standard pip args force `--no-binary=:all:`, which would try to
    # rebuild it from its sdist (needs a Rust toolchain), so install the wheel
    # directly with our own pip invocation against the virtualenv.
    #
    # In short: take the polars wheel we downloaded and install that exact
    # binary into the venv using the system pip (the venv has no pip of its
    # own), without trying to rebuild it or fetch its dependencies.
    python = Formula["python@3.14"].opt_bin/"python3.14"
    resource("polars").stage do
      wheel = Dir["polars-*.whl"].first
      system python, "-m", "pip", "--python=#{venv.root}/bin/python",
             "install", "--verbose", "--no-deps", "--ignore-installed",
             "--no-compile", "--no-build-isolation", wheel
    end
  end

  test do
    system Formula["diffoscope"].opt_bin/"diffoscope", "--help"
    system bin/"container-diffoscope", "--help"
  end
end
