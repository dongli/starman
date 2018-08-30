class Antlr2 < Package
  url 'http://dust.ess.uci.edu/nco/antlr-2.7.7.tar.gz'
  sha256 'c6d3161e888a635fd47f9ecba7c35b2590e3e5d590e7829456228cf2590f5d87'

  label :common

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-csharp
      --disable-java
      --disable-python
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
