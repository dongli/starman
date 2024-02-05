class Tmux < Package
  url 'https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz'
  sha256 'e4fd347843bd0772c4f48d6dde625b0b109b7a380ff15db21e97c11a4dcdf93f'

  label :common

  depends_on :libevent
  depends_on :ncurses
  depends_on :utf8proc

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-utf8proc
      CPPFLAGS='-I#{Utf8proc.link_inc}'
      LDFLAGS='-L#{Utf8proc.link_lib} -lresolv'
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
