class Netcdf < Package
  version '4.9.0'
  label :group

  option 'with-cxx', 'Disable C++ bindings.'

  depends_on 'netcdf-c', version: '4.9.0'
  depends_on 'netcdf-cxx', version: '4.2' if with_cxx?
  depends_on 'netcdf-cxx4', version: '4.3.1' if with_cxx?
  depends_on 'netcdf-fortran', version: '4.6.0'
end
