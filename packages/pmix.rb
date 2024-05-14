class Pmix < Package
  url 'https://github.com/openpmix/openpmix/releases/download/v5.0.2/pmix-5.0.2.tar.bz2'
  sha256 '28227ff2ba925da2c3fece44502f23a91446017de0f5a58f5cea9370c514b83c'

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
