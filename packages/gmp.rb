class Gmp < Package
  url 'https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz'
  sha256 'a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898'

  label :skip_if_exist, library_file: "libgmp.#{OS.soname}"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-cxx
      --with-pic
    ]
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
