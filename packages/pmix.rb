class Pmix < Package
  url 'https://github.com/openpmix/openpmix/releases/download/v4.0.0/pmix-4.0.0.tar.bz2'
  sha256 'feb931660ea372e80dbd2751d76cb4a10ea42c33035c01c3b753900946efe69f'

  label :common

  depends_on :munge
  depends_on :libevent

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-man-pages
      --with-libevent=#{Libevent.link_root}
    ]
    args << "--with-munge=#{Munge.link_root}" unless Munge.skipped?
    run './configure', *args
    run 'make', "-j#{jobs_number}"
    run 'make', 'install'
  end
end
