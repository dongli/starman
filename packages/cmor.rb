class Cmor < Package
  url 'https://github.com/PCMDI/cmor/archive/3.4.0.tar.gz'
  sha256 'e700a6d50f435e6ffdedf23bf6832b7d37fe21dc78815e1372f218d1d52bd2cb'
  file_name 'cmor-3.4.0.tar.gz'

  option 'with-python3', 'Enable support for Python3.'

  depends_on :netcdf
  depends_on :udunits
  depends_on :uuid

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-shared
      --with-hdf5=#{Hdf5.link_root}
      --with-netcdf=#{Netcdf.link_root}
      --with-udunits2=#{Udunits.link_root}
      --with-uuid=#{Uuid.link_root}
    ]
    args << "--with-python=#{`python3-config --prefix`}" if with_python3?
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
