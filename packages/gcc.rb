class Gcc < Package
  url 'http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-12.2.0/gcc-12.2.0.tar.xz'
  sha256 'e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff'

  label :compiler

  resource :mpfr do
    url 'https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.0.tar.xz'
    sha256 '06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993'
  end

  resource :gmp do
    url 'http://mirrors.aliyun.com/gnu/gmp/gmp-6.2.1.tar.xz'
    sha256 'fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2'
  end

  resource :mpc do
    url 'https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz'
    sha256 'ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8'
  end

  resource :isl do
    url 'https://libisl.sourceforge.io/isl-0.25.tar.xz'
    sha256 'be7b210647ccadf90a2f0b000fca11a4d40546374a850db67adb32fad4b230d9'
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
    mv 'mpfr-4.2.0', 'mpfr'
    install_resource :gmp, '.'
    mv 'gmp-6.2.1', 'gmp'
    install_resource :mpc, '.'
    mv 'mpc-1.3.1', 'mpc'
    install_resource :isl, '.'
    mv 'isl-0.25', 'isl'
    mkdir '../gcc-build' do
      run "../gcc-#{version}/configure", *args
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : '', 'bootstrap'
      #run 'ulimit -s 32768 && make -k check' unless skip_test?
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : '', 'install'
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
