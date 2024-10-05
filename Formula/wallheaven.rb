class Wallheaven < Formula
  desc "Random image fetcher for wallhaven.cc"
  homepage "https://github.com/davenicholson-xyz/wallheaven"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/davenicholson-xyz/wallheaven/releases/download/v1.1.1/wallheaven-aarch64-apple-darwin.tar.xz"
      sha256 "f2993f0077dcccb3c98cbe17c6aa040cd24a8e378fde9a3c37a237e31f12ea3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/davenicholson-xyz/wallheaven/releases/download/v1.1.1/wallheaven-x86_64-apple-darwin.tar.xz"
      sha256 "9b79387939f9d55397c3051daf8709a56579d2dbcc8699634e9e58756b1c6d9d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/davenicholson-xyz/wallheaven/releases/download/v1.1.1/wallheaven-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2fd719ddaafdab77885b07fe90c8a98f29f719875a478090777c710c79b5b13c"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wallheaven", "wallheavend" if OS.mac? && Hardware::CPU.arm?
    bin.install "wallheaven", "wallheavend" if OS.mac? && Hardware::CPU.intel?
    bin.install "wallheaven", "wallheavend" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
