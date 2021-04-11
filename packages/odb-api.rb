class OdbApi < Package
  url 'https://confluence.ecmwf.int/download/attachments/61117379/odb_api_bundle-0.18.1-Source.tar.gz?api=v2'
  sha256 '7a01968be0d6f55004d6203a4b9ee06b91accec9078da4103cf71d2879ca2aad'

  depends_on :cmake
  depends_on :yacc
  depends_on :flex
  depends_on :ncurses
  depends_on :eccodes
  depends_on :netcdf

  option 'with-python', 'Build Python2 bindings.'

  def install
    args = std_cmake_args search_paths: [Eccodes.link_root]
    args << '-DENABLE_NETCDF=On'
    args << '-DENABLE_FORTRAN=On'
    args << "-DENABLE_PYTHON=#{with_python? ? 'On' : 'Off'}"
    args << "-DNETCDF_PATH='#{link_inc}'"
    if OS.mac?
      inreplace 'odb_api/CMakeLists.txt', 'ecbuild_add_cxx_flags("-fPIC -Wl,--as-needed")', 'ecbuild_add_cxx_flags("-fPIC")'
    end
    if not Ncurses.skipped?
      args << "-DCURSES_INCLUDE_PATH=#{Ncurses.inc}"
      args << "-DCURSES_LIBRARY=#{Ncurses.lib}/libncursesw.#{OS.soname}"
      inreplace 'eckit/src/eckit/cmd/term.c', {
        '<curses.h>' => '<ncursesw/curses.h>',
        '<term.h>' => '<ncursesw/term.h>'
      }
    end
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make', 'install'
    end
  end
end
