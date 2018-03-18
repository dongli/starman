class Munge < Package
  url 'https://github.com/dun/munge/archive/munge-0.5.13.tar.gz'
  sha256 '93a0fb2e9761958a6b0dac88bd43c1b14598cfbbced937fbbeeec3b3039b25c3'
  file_name 'munge-0.5.13.tar.gz'

  label :common

  depends_on :openssl

  def install
    args = %W[
      --prefix=#{prefix}
      --with-crypto-lib=openssl
      --with-openssl-prefix=#{Openssl.prefix}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
