class Libevent < Package
  url 'https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz'
  sha256 '965cc5a8bb46ce4199a47e9b2c9e1cae3b137e8356ffdad6d94d3b9069b71dc2'
  version '2.1.8'

  label :common

  depends_on :openssl

  def install
    ENV['CPPFLAGS'] += " -I#{Openssl.inc}"
    ENV['LDFLAGS'] += " -L#{Openssl.lib}"
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug-mode
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
