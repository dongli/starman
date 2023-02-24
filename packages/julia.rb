class Julia < Package
  if OS.linux?
    url 'https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz'
    sha256 'e71a24816e8fe9d5f4807664cbbb42738f5aa9fe05397d35c81d4c5d649b9d05'
  end
  version '1.8.5'

  label :common

  def install
    mkdir prefix
    mv 'bin', prefix
    mv 'etc', prefix
    mv 'include', prefix
    mv 'lib', prefix
    mv 'libexec', prefix
    mv 'share', prefix
  end
end
