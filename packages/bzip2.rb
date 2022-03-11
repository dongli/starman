class Bzip2 < Package
  url 'https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz'
  sha256 'ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269'

  label :skip_if_exist, library_file: "libbz2.#{OS.soname}.1"

  def install
    inreplace 'Makefile', '$(PREFIX)/man', '$(PREFIX)/share/man'
    run 'make', 'install', "PREFIX=#{prefix}"
  end
end
