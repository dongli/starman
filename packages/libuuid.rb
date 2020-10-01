class Libuuid < Package
  url 'https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.34/util-linux-2.34.tar.gz'
  sha256 'b62c92e5e1629642113cd41cec1ee86d1ee7e36b8ffe8ec3ac89c11797e9ac25'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-silent-rules
      --disable-all-programs
      --enable-libuuid
    ]
    run './configure', *args
    inreplace 'Makefile', {
      'am__append_439 = bash-completion/uuidgen' => '#am__append_439 = bash-completion/uuidgen'
    }
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
    rm bin
    rm sbin
  end
end
