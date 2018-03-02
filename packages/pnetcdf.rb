class Pnetcdf < Package
  url 'http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/parallel-netcdf-1.9.0.tar.gz'
  sha256 '356e1e1fae14bc6c4236ec11435cfea0ff6bde2591531a4a329f9508a01fbe98'

  option 'without-cxx', 'Disable C++ bindings'
  option 'without-fortran', 'Disable Fortran bindings'

  def install
    args = %W[--prefix=#{prefix}]
    args << '--disable-cxx' if without_cxx?
    args << '--disable-fortran' if without_fortran?
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
