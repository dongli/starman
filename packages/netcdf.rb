class Netcdf < Package
  version '4.6.0'
  label :group
  depends_on 'netcdf-c', version: '4.6.0'
  depends_on 'netcdf-fortran', version: '4.4.4'
end