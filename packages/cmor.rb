class Cmor < Package
  url 'https://github.com/PCMDI/cmor/archive/3.5.0.tar.gz'
  sha256 '37ce11332f9adfd4fa7560dfb358d14b300315221614c4a44c7407297103c62a'
  file_name 'cmor-3.5.0.tar.gz'

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
      --with-hdf5=#{Hdf5.link_root}
      --with-netcdf=#{Netcdf.link_root}
      --with-udunits2=#{Udunits.link_root}
      --with-uuid=#{Libuuid.link_root}
    ]
    args << "--with-python=#{`python3-config --prefix`}" if with_python3?
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
