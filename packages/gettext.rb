class Gettext < Package
  url 'https://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz'
  sha256 '105556dbc5c3fbbc2aa0edb46d22d055748b6f5c7cd7a8d99f8e7eb84e938be4'

  label :common
  label :skip_if_exist, library_file: 'libgettextpo.so.0' if OS.linux?

  depends_on :libxml2

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-debug
      --prefix=#{prefix}
      --with-included-gettext
      --with-included-glib
      --with-included-libcroco
      --with-included-libunistring
      --disable-java
      --disable-csharp
      --without-git
      --without-cvs
      --without-xz
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
