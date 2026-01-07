# typed: strict
# frozen_string_literal: true

class Usbfluxd < Formula
  desc "Redirects usbmuxd socket to allow remote iOS device connections"
  homepage "https://github.com/corellium/usbfluxd"
  url "https://github.com/corellium/usbfluxd/archive/refs/tags/v1.0.tar.gz"
  sha256 "ee76f81a30247288f3880f1d54815447dc43cc667a3db10c0ae677d700ff89bb"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  def caveats
    <<~EOS
      usbfluxd requires root permissions to run.
      To start usbfluxd, use:
        sudo #{opt_sbin}/usbfluxd

      For foreground mode with verbose output:
        sudo #{opt_sbin}/usbfluxd -f -v
    EOS
  end

  test do
    assert_match "usbfluxd", shell_output("#{sbin}/usbfluxd -h 2>&1", 1)
  end
end
