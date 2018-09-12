class Flex < Package
  url 'https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz'
  sha256 'e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995'

  label :common
  label :skip_if_exist, binary_file: 'flex'

  depends_on :gettext

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
