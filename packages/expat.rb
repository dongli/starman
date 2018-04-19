class Expat < Package
  url 'https://downloads.sourceforge.net/project/expat/expat/2.2.5/expat-2.2.5.tar.bz2'
  sha256 'd9dc32efba7e74f788fcc4f212a43216fc37cf5f23f4c2339664d473353aedf6'

  label :common

  def install
    run './configure', "--prefix=#{prefix}"
    run 'make', 'install'
  end
end
