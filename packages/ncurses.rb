class Ncurses < Package
  url 'https://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz'
  mirror 'https://ftpmirror.gnu.org/ncurses/ncurses-6.1.tar.gz'
  sha256 'aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17'

  label :common
  label :alone
  label :skip_if_exist, library_file: "libncursesw.#{OS.soname}.6"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-pc-files
      --with-pkg-config-libdir=#{lib}/pkgconfig
      --enable-sigwinch
      --enable-symlinks
      --enable-widec
      --with-shared
      --with-gpm=no
    ]
    run './configure', *args
    run 'make', 'install'
    # Why there is no libncurses.so file?
    run 'ln -s', lib + '/libncursesw.' + OS.soname, lib + '/libncurses.' + OS.soname
  end
end

