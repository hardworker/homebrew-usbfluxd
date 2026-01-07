# typed: strict
# frozen_string_literal: true

class Usbfluxd < Formula
  desc "Redirects usbmuxd socket to allow remote iOS device connections"
  homepage "https://github.com/corellium/usbfluxd"
  url "https://github.com/corellium/usbfluxd.git",
      revision: "608cb24e08135f7b365ace7e9cfa54243838e508"
  version "1.2.1"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"

  def install
    ENV.prepend_path "PATH", Formula["pkgconf"].opt_bin
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
