class Cmor < Package
  url 'https://github.com/PCMDI/cmor/archive/3.6.1.tar.gz'
  sha256 '991035a41424f72ea6f0f85653fc13730eb035e63c7dff6ca740aa7a70976fb4'
  file_name 'cmor-3.6.1.tar.gz'

  option 'with-python3', 'Enable support for Python3.'

  depends_on 'json-c'
  depends_on :netcdf
  depends_on :udunits
  depends_on :libuuid

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-shared
      --with-json-c=#{JsonC.link_root}
      --with-netcdf=#{Netcdf.link_root}
      --with-udunits2=#{Udunits.link_root}
      --with-uuid=#{Libuuid.link_root}
    ]
    args << "--with-python=#{`python3-config --prefix`}" if with_python3?
    run './configure', *args
    run 'make'
    run 'make', 'test' unless skip_test?
    run 'make', 'install'
  end
end
