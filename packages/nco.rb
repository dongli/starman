class Nco < Package
  url 'https://github.com/nco/nco/archive/4.9.8.tar.gz'
  sha256 '1ef3e887f0841cec3b117ec14830b7d002f7a3a4d0e33a95ae1aa66d0d66ee4b'
  file_name 'nco-4.9.8.tar.gz'

  label :common

  depends_on :antlr2
  depends_on :flex
  depends_on :gsl
  depends_on :netcdf
  depends_on :udunits

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-netcdf4
      --enable-dap
      --enable-ncap2
      --enable-udunits2
      --enable-optimize-custom
      --disable-doc
      NETCDF_INC=#{Netcdf.link_inc}
      NETCDF_LIB=#{Netcdf.link_lib}
      NETCDF4_ROOT=#{Netcdf.link_root}
      NETCDF_ROOT=#{Netcdf.link_root}
      UDUNITS2_PATH=#{Udunits.link_root}
      ANTLR_ROOT=#{Antlr2.link_root}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'check' if not skip_test?
    run 'make', 'install'
  end
end
