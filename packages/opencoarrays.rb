class Opencoarrays < Package
  url 'https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz'
  sha256 'b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4'

  depends_on :cmake
  depends_on :mpi

  def install
    if CompilerSet.c.vendor != :gcc
      CLI.error 'OpenCoarrays only works with GNU compilers!'
    end
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args
      run 'make'
      run 'make', 'install'
    end
  end
end
