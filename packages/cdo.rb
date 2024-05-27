class Cdo < Package
  url 'https://code.mpimet.mpg.de/attachments/download/29019/cdo-2.3.0.tar.gz'
  sha256 '10c878227baf718a6917837527d4426c2d0022cfac4457c65155b9c57f091f6b'

  label :common

  depends_on :eccodes
  depends_on :hdf5
  depends_on :libaec
  depends_on :netcdf
  depends_on :proj

  def install
    ENV['LDFLAGS'] = "-L#{Eccodes.lib64}"
    if Hdf5.enable_parallel?
      ENV['CC'] = ENV['MPICC']
      ENV['CXX'] = ENV['MPICXX']
      ENV['FC'] = ENV['MPIFC']
    end
    args = %W[
      --prefix=#{prefix}
      --with-hdf5=#{Hdf5.prefix}
      --with-netcdf=#{Netcdf.prefix}
      --with-zlib=#{Zlib.prefix}
      --with-szlib=#{Szip.prefix}
      --with-eccodes=#{Eccodes.prefix}
      --with-proj=#{Proj.prefix}
      --disable-dependency-tracking
      --disable-debug
      LIBS='-lz'
    ]
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
