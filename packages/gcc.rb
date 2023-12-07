class Gcc < Package
  url 'http://mirrors.aliyun.com/gnu/gcc/gcc-12.3.0/gcc-12.3.0.tar.xz'
  sha256 '949a5d4f99e786421a93b532b22ffab5578de7321369975b91aec97adfda8c3b'

  label :compiler

  resource :mpfr do
    url 'http://mirrors.aliyun.com/gnu/mpfr/mpfr-4.2.0.tar.xz'
    sha256 '06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993'
  end

  resource :gmp do
    url 'http://mirrors.aliyun.com/gnu/gmp/gmp-6.3.0.tar.xz'
    sha256 'a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898'
  end

  resource :mpc do
    url 'http://mirrors.aliyun.com/gnu/mpc/mpc-1.3.1.tar.gz'
    sha256 'ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8'
  end

  resource :isl do
    url 'https://libisl.sourceforge.io/isl-0.26.tar.xz'
    sha256 'a0b5cb06d24f9fa9e77b55fabbe9a3c94a336190345c2555f9915bb38e976504'
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
