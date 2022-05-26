class Xz < Package
  url 'https://downloads.sourceforge.net/project/lzmautils/xz-5.2.5.tar.gz'
  sha256 'f6f4910fd033078738bd82bfba4f49219d03b17eb0794eb91efbae419f4aba10'

  label :common

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
