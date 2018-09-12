class Yacc < Package
  url 'https://invisible-mirror.net/archives/byacc/byacc-20170709.tgz'
  sha256 '27cf801985dc6082b8732522588a7b64377dd3df841d584ba6150bc86d78d9eb'
  version '2017.07.09'

  label :common
  label :skip_if_exist, binary_file: 'yacc'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
