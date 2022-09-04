class Nceplibs < Package
  url 'https://github.com/NOAA-EMC/NCEPLIBS/archive/refs/tags/v1.4.0.zip'
  sha256 'b952e116a0b7b94fdb022b9ecf40440163b872ff65461035337b3436cb72c1a8'
  file_name 'nceplibs-1.4.0.zip'

  label :alone

  depends_on :hdf5
  depends_on :netcdf
  depends_on :jasper
  depends_on :jpeg
  depends_on :libpng

  def install
    ENV['JPEG_ROOT'] = Jpeg.prefix
    run "sed -i 's@\"-DOPENMP=\${OPENMP}\"@\"-DOPENMP=\${OPENMP}\"\\n\"-DJasper_ROOT=#{Jasper.prefix}\"\\n\"-DPNG_ROOT=#{Libpng.prefix}\"@' CMakeLists.txt"
    run "sed -i 's@\"-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}\"@\"-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}\"\\n\"-DPNG_ROOT=#{Libpng.prefix}\"@' CMakeLists.txt"
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : '', :allow_failure
      inreplace '../download/nceplibs-w3emc/CMakeModules/Modules/FindNetCDF.cmake', {
        /set\(_C_libs_flag --libs\)/ => <<-EOF
          set(NetCDF_C_CONFIG_EXECUTABLE \"#{Netcdf.bin}/nc-config\")
          set(NetCDF_Fortran_CONFIG_EXECUTABLE "#{Netcdf.bin}/nf-config")
          set(_C_libs_flag --libs)
      EOF
      }
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    end
  end
end
