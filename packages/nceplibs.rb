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

  resource :bacio do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-bacio/archive/refs/tags/v2.4.1.zip'
    sha256 'd4b7ee11ede7d54d3abe94f4757230bd072634dc8e917c8153da52b9d184c7e3'
    file_name 'nceplibs-bacio-2.4.1.zip'
  end

  resource :sigio do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-sigio/archive/refs/tags/v2.3.2.zip'
    sha256 'a2c394a206e0568baeb8c15f774dae4df5060a993556a3d83fc1ca2fc623c035'
    file_name 'nceplibs-sigio-2.3.2.zip'
  end

  resource :bufr do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-bufr/archive/refs/tags/bufr_v11.5.0.zip'
    sha256 'f82f3742c3b1fc99ebc1a9a58740c0120fc40a7a3d55d98372977454678be115'
    file_name 'nceplibs-bufr-11.5.0.zip'
  end

  resource :crtm do
    url 'https://github.com/NOAA-EMC/EMC_crtm/archive/refs/tags/v2.3.0.zip'
    sha256 'e2aaabce01e0cc2382335b484875e17749a093999ace5eca0a088596adb30713'
    file_name 'emc-crtm-2.3.0.zip'
  end

  resource :g2 do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-g2/archive/refs/tags/v3.4.5.zip'
    sha256 'ed237e5d880f617981a6cca79e2b3bac045add8b4a6264be7d86e7cafd9cdddc'
    file_name 'nceplibs-g2-3.4.5.zip'
  end

  resource :g2c do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-g2c/archive/refs/tags/v1.6.2.zip'
    sha256 '7bd5c5050e708cd1bfa6031b884921fdf2fcba1af851d18cfa426008332fc62d'
    file_name 'nceplibs-g2c-1.6.2.zip'
  end

  resource :g2tmpl do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-g2tmpl/archive/refs/tags/v1.9.1.zip'
    sha256 'c654312f651888d2aca9cfde2fe0aa0a3b602cd5f15eedb08f60c85d4b5a0efb'
    file_name 'nceplibs-g2tmpl-1.9.1.zip'
  end

  resource :gfsio do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-gfsio/archive/refs/tags/v1.4.1.zip'
    sha256 'cffdfb03381cd9e90aad7edce858a9f8b3446680c559da11f37a0f6414028274'
    file_name 'nceplibs-gfsio-1.4.1.zip'
  end

  resource :ip do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-ip/archive/refs/tags/v3.3.3.zip'
    sha256 'ff996c78d31a35d1df7cfe001063fd49df986bd7f30fdf6f375ba7fe61c392b7'
    file_name 'nceplibs-ip-3.3.3.zip'
  end

  resource :landsfcutil do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-landsfcutil/archive/refs/tags/v2.4.1.zip'
    sha256 '5085fe5de1cd088b47f55457d7034f3c3e6c6a1826a0a7d3cad08088b9b70219'
    file_name 'nceplibs-landsfcutil-2.4.1.zip'
  end

  resource :nemsio do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-nemsio/archive/refs/tags/v2.5.2.zip'
    sha256 '5fd856b4e72ec051822aead18083eed30b78c4ba134eea0b25da80a6b95fce2d'
    file_name 'nceplibs-nemsio-2.5.2.zip'
  end

  resource :nemsiogfs do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-nemsiogfs/archive/refs/tags/v2.5.3.zip'
    sha256 '01336dfe35701f96339cc171fad88a21ccb347ddf55a34ce5fd0fa47f67e46c5'
    file_name 'nceplibs-nemsiogfs-2.5.3.zip'
  end

  resource :sfcio do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-sfcio/archive/refs/tags/v1.4.1.zip'
    sha256 '7c75462ae63c5980427f272a016b34068605735973fb2874ad40b7f8d5f470a6'
    file_name 'nceplibs-sfcio-1.4.1.zip'
  end

  resource :sp do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-sp/archive/refs/tags/v2.3.3.zip'
    sha256 'be6c95d3bf163eadcbc9e249e7f0b0528da2d712db29753b7ddd4b95970a2505'
    file_name 'nceplibs-sp-2.3.3.zip'
  end

  resource :w3emc do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-w3emc/archive/refs/tags/v2.7.3.zip'
    sha256 '723c5750a44d3af31f30036ac3b382a61eb790f04376c09977e6834834338cf4'
    file_name 'nceplibs-w3emc-2.7.3.zip'
  end

  resource :w3nco do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-w3nco/archive/refs/tags/v2.4.1.zip'
    sha256 '6b84ce58ed597054d6cdc47af3227e159767983d155cba30187011ee3773fe18'
    file_name 'nceplibs-w3nco-2.4.1.zip'
  end

  resource :wrf_io do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-wrf_io/archive/refs/tags/v1.2.0.zip'
    sha256 '4a7d542f622bbed9de31c858b59f75fea77c400bc83fd3cfcb7dd2da128ac1b2'
    file_name 'nceplibs-wrf_io-1.2.0.zip'
  end

  resource :ip2 do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-ip2/archive/refs/tags/v1.1.2.zip'
    sha256 'c71687c4c64103dad925383f91ecc22209fd85e3e3f3d629b0f297c10d9875dd'
    file_name 'nceplibs-ip2-1.1.2.zip'
  end

  resource :wgrib2 do
    url 'https://github.com/NOAA-EMC/NCEPLIBS-wgrib2/archive/refs/tags/v2.0.8-cmake-v6.zip'
    sha256 '783530bb46ff5618f0412f646a8599c57d4716b639a555753cd85693508d3395'
    file_name 'nceplibs-wgrib2-2.0.8.zip'
  end

  resource :post do
    url 'https://github.com/NOAA-EMC/UPP/archive/refs/tags/upp_v10.0.0.zip'
    sha256 '1d0c4b30d8a588e601ddab901a4e33c2561ea869a104270fb60f9c23bc59f88f'
    file_name 'nceplibs-upp-10.0.0.zip'
  end

  def install
    run "sed -i 's@\"-DOPENMP=\${OPENMP}\"@\"-DOPENMP=\${OPENMP}\"\\n\"-DJasper_ROOT=#{Jasper.prefix}\"\\n\"-DPNG_ROOT=#{Libpng.prefix}\"@' CMakeLists.txt"
    run "sed -i 's@\"-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}\"@\"-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}\"\\n\"-DPNG_ROOT=#{Libpng.prefix}\"@' CMakeLists.txt"
    mkdir 'download' do
      resources.keys.each do |key|
        install_resource key, '.'
        if [:crtm, :post].include? key
          mv key.to_s, "emc_#{key}"
        else
          mv key.to_s, "nceplibs-#{key}"
        end
      end
      ['nceplibs-w3emc', 'emc_post'].each do |lib|
        cp 'nceplibs-wrf_io/cmake/FindNetCDF.cmake', "#{lib}/cmake"
        run "sed -i 's@/CMakeModules/Modules@/cmake@' #{lib}/CMakeLists.txt"
      end
      run "sed -i 's@add_subdirectory(test)@#add_subdirectory(test)@' nceplibs-bufr/CMakeLists.txt"
    end
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args, '-DUSE_LOCAL=ON', "-DCMAKE_MODULE_PATH=../download/nceplibs-wgrib2/cmake/"
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    end
  end
end
