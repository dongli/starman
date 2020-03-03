class Gcc < Package
  url 'https://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz'
  sha256 'ea6ef08f121239da5695f76c9b33637a118dcf63e24164422231917fa61fb206'

  label :compiler

  resource :mpfr do
    url 'http://www.mpfr.org/mpfr-current/mpfr-4.0.2.tar.bz2'
    sha256 'c05e3f02d09e0e9019384cdd58e0f19c64e6db1fd6f5ecf77b4b1c61ca253acc'
  end

  resource :gmp do
    url 'https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2'
    sha256 '5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2'
  end

  resource :mpc do
    url 'https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz'
    sha256 '6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e'
  end

  resource :isl do
    url 'ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2'
    sha256 '6b8b0fd7f81d0a957beb3679c81bbb34ccc7568d5682844d8924424a0dadcb1b'
  end

  option 'disable-lto', 'Disable Link Time Optimisation support.'

  def export_env
    append_ld_library_path "#{lib}/gcc/lib64"
  end

  def build_name
    if OS.mac?
      'x86_64-apple-darwin'
    elsif OS.linux?
      'x86_64-pc-linux-gnu'
    else
      'unknown'
    end
  end

  def install
    ENV['LIBRARY_PATH'] = ''
    if CompilerSet.c.version <= '4.8.5'
      CLI.warning 'Using old GCC (<= 4.8.5), so STARMAN made some tricks!'
      inreplace 'gcc/Makefile.in', 'mv tmp-specs $(SPECS)', '#mv tmp-specs $(SPECS)'
      self.disable_lto = true
    end
    if OS.redhat?
      CLI.warning 'STARMAN is trying hard to fix GCC build for Red Hat Enterprise Linux!'
      Dir.glob('libgfortran/generated/*.F90').concat(['libgfortran/libgfortran.h', 'libgfortran/ieee/ieee_exceptions.F90', 'libgfortran/ieee/ieee_arithmetic.F90']).each do |file|
        inreplace file, '"config.h"', "\"#{pwd}/../gcc-build/#{build_name}/libgfortran/config.h\""
      end
    end
    if CompilerSet.c.vendor == :gcc
      ENV['CC']  += " -I#{`gcc --print-file-name=include`.chomp}"
      ENV['CXX'] += " -I#{`gcc --print-file-name=include`.chomp}"
    end
    args = %W[
      --prefix=#{prefix}
      --build=#{build_name}
      --enable-languages=c,c++,fortran
      --disable-multilib
      --enable-libstdcxx-time=yes
      --enable-stage1-checking
      --enable-checking=release
      --with-build-config=bootstrap-debug
      --disable-werror
      --disable-nls
    ]
    args << '--enable-lto' unless disable_lto?
    install_resource :mpfr, '.'
    mv 'mpfr-4.0.2', 'mpfr'
    install_resource :gmp, '.'
    mv 'gmp-6.1.2', 'gmp'
    install_resource :mpc, '.'
    mv 'mpc-1.1.0', 'mpc'
    install_resource :isl, '.'
    mv 'isl-0.18', 'isl'
    mkdir '../gcc-build' do
      run "../gcc-#{version}/configure", *args
      run 'make', '-j8', 'bootstrap'
      #run 'ulimit -s 32768 && make -k check' unless skip_test?
      run 'make', '-j8', 'install'
    end
  end

  def post_install
    # Update conf file to add this new compiler set.
    Settings.settings['compiler_sets']["gcc_#{version}"] = {
      'c' => "#{bin}/gcc",
      'cxx' => "#{bin}/g++",
      'fortran' => "#{bin}/gfortran"
    }
    Settings.write
  end
end
