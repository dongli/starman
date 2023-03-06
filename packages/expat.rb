class Expat < Package
  url 'https://github.com/libexpat/libexpat/releases/download/R_2_4_1/expat-2.4.1.tar.xz'
  sha256 'cf032d0dba9b928636548e32b327a2d66b1aab63c4f4a13dd132c2d1d2f2fb6a'

  label :common

  def install
    run './configure', "--prefix=#{prefix} --without-docbook"
    run 'make', 'install'
  end
end
