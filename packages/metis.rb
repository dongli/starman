class Metis < Package
  url 'https://github.com/KarypisLab/METIS/archive/refs/tags/v5.2.1.tar.gz'
  sha256 '1a4665b2cd07edc2f734e30d7460afb19c1217c2547c2ac7bf6e1848d50aff7a'
  file_name 'metis-5.2.1.tar.gz'

  resource :gklib do
    url 'https://codeload.github.com/KarypisLab/GKlib/zip/8bd6bad750b2b0d90800c632cf18e8ee93ad72d7'
    sha256 '6a76af30d708e2d2ad11cdac224aa50d7f58abff24963fffa4ef5250fc4c39de'
    file_name 'gklib-8bd6ba.zip'
  end

  def install
    args = %W[
      shared=1
      cc=#{CompilerSet.c.command}
      gklib_path=#{prefix}
      prefix=#{prefix}
    ]
    # Install GKLib.
    install_resource :gklib, '.'
    work_in 'gklib' do
      if OS.centos?
        inreplace 'GKlibSystem.cmake', {
          '# Finally set the official C flags.' =>
          'set(GKlib_COPTIONS "${GKlib_COPTIONS} -D_POSIX_C_SOURCE=199309L")'
        }
      end
      run 'make', 'config', *args
      run 'make', 'install'
    end
    inreplace 'libmetis/CMakeLists.txt', {
      'add_library(metis ${METIS_LIBRARY_TYPE} ${metis_sources})' =>
      "add_library(metis ${METIS_LIBRARY_TYPE} ${metis_sources})\ntarget_link_libraries(metis GKlib)"
    }
    run 'make', 'config', *args
    run 'make', 'install'
  end
end
