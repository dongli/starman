class Netcdf < Package
  version '4.6.0'
  label :group
  depends_on 'netcdf-c', version: '4.6.0'
  depends_on 'netcdf-cxx', version: '4.2'
  depends_on 'netcdf-cxx4', version: '4.3.0'
  depends_on 'netcdf-fortran', version: '4.4.4'
end
