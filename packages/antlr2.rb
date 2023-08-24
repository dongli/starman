class Antlr2 < Package
  url 'https://www.antlr2.org/download/antlr-2.7.7.tar.gz'
  sha256 '853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9'

  label :common

  def install
    inreplace 'lib/cpp/antlr/CharScanner.hpp', {
      '#include <map>' => "#include <map>\n#include <string.h>"
    }
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
