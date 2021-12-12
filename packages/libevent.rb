# The libevent API provides a mechanism to execute a callback function when a
# specific event occurs on a file descriptor or after a timeout has been
# reached. Furthermore, libevent also support callbacks due to signals or
# regular timeouts.
#
# libevent is meant to replace the event loop found in event driven network
# servers. An application just needs to call event_dispatch() and then add or
# remove events dynamically without having to change the event loop.

class Libevent < Package
  url 'https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz'
  sha256 '92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb'

  label :common

  depends_on :openssl

  def install
    if not Openssl.skipped?
      ENV['CPPFLAGS'] += " -I#{Openssl.inc}"
      ENV['LDFLAGS'] += " -L#{Openssl.lib}"
    end
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
