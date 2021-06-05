class Gcc < Package
  url 'http://mirrors.aliyun.com/gnu/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz'
  sha256 '4c4a6fb8a8396059241c2e674b85b351c26a5d678274007f076957afa1cc9ddf'

  label :compiler

  resource :mpfr do
    url 'https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.bz2'
    sha256 'feced2d430dd5a97805fa289fed3fc8ff2b094c02d05287fd6133e7f1f0ec926'
  end

  resource :gmp do
    url 'http://mirrors.aliyun.com/gnu/gmp/gmp-6.2.1.tar.xz'
    sha256 'fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2'
  end

  resource :mpc do
    url 'http://mirrors.aliyun.com/gnu/mpc/mpc-1.2.1.tar.gz'
    sha256 '17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459'
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
