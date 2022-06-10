class Libffi < Package
  url 'https://github.com/libffi/libffi/releases/download/v3.4.2/libffi-3.4.2.tar.gz'
  sha256 '540fb721619a6aba3bdeef7d940d8e9e0e6d2c193595bc243241b77ff9e93620'

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
