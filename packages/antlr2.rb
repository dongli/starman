class Antlr2 < Package
  url 'http://dust.ess.uci.edu/nco/antlr-2.7.7.tar.gz'
  sha256 '853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9'

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
