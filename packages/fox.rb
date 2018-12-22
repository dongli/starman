class Fox < Package
  url 'http://homepages.see.leeds.ac.uk/~earawa/FoX/source/FoX-4.1.2.tar.gz'
  sha256 '3b749138229e7808d0009a97e2ac47815ad5278df6879a9cc64351a7921ba06f'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fast
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
