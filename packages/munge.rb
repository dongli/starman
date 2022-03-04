# MUNGE (MUNGE Uid 'N' Gid Emporium) is an authentication service for creating
# and validating credentials.  It is designed to be highly scalable for use in
# an HPC cluster environment. It allows a process to authenticate the UID and
# GID of another local or remote process within a group of hosts having common
# users and groups. These hosts form a security realm that is defined by a
# shared cryptographic key. Clients within this security realm can create and
# validate credentials without the use of root privileges, reserved ports, or
# platform-specific methods.

class Munge < Package
  url 'https://github.com/dun/munge/archive/munge-0.5.14.tar.gz'
  sha256 '5d97b4df164f26e0fb9b86a215e646b2311fa79a2fe9aaaeac067f4ed906220a'

  label :common
  label :skip_if_exist, binary_file: 'munge'

  depends_on :openssl

  def install
    args = %W[
      --prefix=#{prefix}
      --with-crypto-lib=openssl
    ]
    args << "--with-openssl-prefix=#{Openssl.prefix}" if not Openssl.skipped?
    run './bootstrap'
    run './configure', *args
    run 'make'
    #run 'make', 'check' if not skip_test?
    run 'make', 'install'
    run "chmod 0600 #{prefix}/etc/munge/munge.key"
  end
end
