class M4 < Package
  url 'https://mirrors.nju.edu.cn/gnu/m4/m4-1.4.19.tar.xz'
  sha256 '63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96'

  label :common
  label :skip_if_exist, binary_file: 'm4'

  def install
    run './configure', "--prefix=#{prefix}"
    run 'make'
    run 'make', 'install'
  end
end
