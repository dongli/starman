class Uuid < Package
  url 'https://mirrors.ocf.berkeley.edu/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz'
  sha256 '11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0'
  version '1.6.2'

  def install
    args = %W[
      --prefix=#{prefix}
      --without-perl
      --without-php
      --without-pgsql
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
