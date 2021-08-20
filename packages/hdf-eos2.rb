class HdfEos2 < Package
  url 'https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos/cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS2.20v1.00.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS2.20v1.00.tar.Z'
  sha256 'cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903'
  version '2.20'
  file_name 'HDF-EOS2.20v1.00.tar.Z'

  depends_on :hdf4
  depends_on :jpeg
  depends_on :szip
  depends_on :zlib

  def install
    args = %W[
      --prefix=#{prefix}
      --with-hdf4=#{link_root}
      --with-zlib=#{link_root}
      --with-szlib=#{link_root}
      CC='#{link_bin}/h4cc -Df2cFortran'
    ]
    args << "--with-jpeg=#{OS.mac? ? Jpeg.prefix : link_root}"
    run './configure', *args
    run 'make'
    run 'make', 'install'
    work_in 'include' do
      run 'make', 'install'
    end
  end
end
