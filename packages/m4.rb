class M4 < Package
  url 'http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz'
  sha256 'ab2633921a5cd38e48797bf5521ad259bdc4b979078034a3b790d7fec5493fab'

  label :common
  label :skip_if_exist, binary_file: 'm4'

  def install
    run './configure', "--prefix=#{prefix}"
    run 'make'
    run 'make', 'install'
  end
end
