class Expat < Package
  url 'https://github.com/libexpat/libexpat/releases/download/R_2_3_0/expat-2.3.0.tar.xz'
  sha256 'caa34f99b6e3bcea8502507eb6549a0a84510b244a748dfb287271b2d47467a9'

  label :common

  def install
    run './configure', "--prefix=#{prefix}"
    run 'make', 'install'
  end
end
