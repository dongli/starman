class Libffi < Package
  url 'https://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz'
  sha256 'd06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37'

  label :common
  label :skip_if_exist, include_file: 'ffi.h'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]
    run './configure', *args
    run 'make', 'install'
    # Move header files into normal path.
    CLI.notice 'Fix bad header location.'
    mkdir inc
    mv "#{lib}/libffi-#{version}/include/*", inc
    inreplace "#{lib}/pkgconfig/libffi.pc",
      "includedir=${libdir}/libffi-#{version}/include",
      "includedir=${exec_prefix}/include"
    rm "#{lib}/libffi-#{version}"
  end
end
