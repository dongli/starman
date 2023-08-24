class Proj < Package
  url 'https://github.com/OSGeo/PROJ/releases/download/8.2.0/proj-8.2.0.tar.gz'
  sha256 'de93df9a4aa88d09459ead791f2dbc874b897bf67a5bbb3e4b68de7b1bdef13c'

  depends_on :sqlite3
  depends_on :libtiff

  def install
    if CompilerSet.c.vendor == :gcc and CompilerSet.c.version >= '13'
      inreplace 'src/proj_json_streaming_writer.hpp', {
        '#include <string>' => "#include <string>\n#include <cstdint>"
      }
      inreplace 'src/projections/s2.cpp', {
        '#include <cmath>' => "#include <cmath>\n#include <cstdint>"
      }
    end
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      TIFF_CFLAGS='-I#{Libtiff.inc}'
      TIFF_LIBS='-L#{Libtiff.lib} -ltiff'
      --without-curl
    ]
    args << "SQLITE3_CFLAGS='-I#{Sqlite3.inc}'"
    args << "SQLITE3_LIBS='-L#{Sqlite3.lib} -lsqlite3'"
    run './configure', *args
    run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'install'
  end
end
