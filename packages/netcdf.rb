class Netcdf < Package
  version '4.7.2'
  label :group

  option 'without-cxx', 'Disable C++ bindings.'

  depends_on 'netcdf-c', version: '4.7.2'
  depends_on 'netcdf-cxx', version: '4.2' unless without_cxx?
  depends_on 'netcdf-cxx4', version: '4.3.1' unless without_cxx?
  depends_on 'netcdf-fortran', version: '4.5.2'
end
