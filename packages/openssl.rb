class Openssl < Package
  url 'https://www.openssl.org/source/openssl-1.0.2n.tar.gz'
  sha256 '370babb75f278c39e0c50e8c4e7493bc0f18db6867478341a832a982fd15a8fe'
  version '1.0.2n'

  label :common
  label :alone

  depends_on :zlib

  def install
    # OpenSSL will prefer the PERL environment variable if set over $PATH
    # which can cause some odd edge cases & isn't intended. Unset for safety,
    # along with perl modules in PERL5LIB.
    ENV.delete 'PERL'
    ENV.delete 'PERL5LIB'

    # Load zlib from an explicit path instead of relying on dyld's fallback
    # path, which is empty in a SIP context. This patch will be unnecessary
    # when we begin building openssl with no-comp to disable TLS compression.
    # https://langui.sh/2015/11/27/sip-and-dlopen
    if OS.mac?
      inreplace 'crypto/comp/c_zlib.c',
                'zlib_dso = DSO_load(NULL, "z", NULL, 0);',
                'zlib_dso = DSO_load(NULL, "/usr/lib/libz.dylib", NULL, DSO_FLAG_NO_NAME_TRANSLATION);'
    end

    inreplace 'Configure', 'if $cc eq "gcc"', 'if $cc =~ /gcc$/'

    args = %W[
      --prefix=#{prefix}
      --with-zlib-include=#{Zlib.inc}
      no-ssl2
      zlib-dynamic
      shared
      enable-cms
    ]
    if OS.linux?
      args << 'linux-x86_64'
    elsif OS.mac?
      args << 'darwin64-x86_64-cc'
      args << 'enable-ec_nistp_64_gcc_128'
    end
    run 'perl', './Configure', *args
    run 'make', 'depend'
    run 'make'
    run 'make', 'test' unless skip_test?
    run 'make', 'install'
  end
end
