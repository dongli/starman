class Python3 < Package
  url 'https://www.python.org/ftp/python/3.9.9/Python-3.9.9.tar.xz'
  sha256 '06828c04a573c073a4e51c4292a27c1be4ae26621c3edc7cf9318418ce3b6d27'

  label :skip_if_exist, binary_file: 'python3.9'

  label :common

  depends_on :readline
  depends_on :openssl
  depends_on :libffi

  option 'without-dtrace', 'Disable DTrace support.'

  resource :setuptools do
    url 'https://files.pythonhosted.org/packages/cd/9a/6fff2cee92de1d34c0e8d48bb2ccedb0899eebb2cfe7955584b53bdaded7/setuptools-59.0.1.tar.gz'
    sha256 '899d27ec8104a68d4ba813b1afd66708a1a10e9391e79be92c8c60f9c77d05e5'
  end

  resource :pip do
    url 'https://files.pythonhosted.org/packages/da/f6/c83229dcc3635cdeb51874184241a9508ada15d8baa337a41093fab58011/pip-21.3.1.tar.gz'
    sha256 'fd11ba3d0fdb4c07fbc5ecbba0b1b719809420f25038f8ee3cd913d3faa3033a'
  end

  resource :wheel do
    url 'https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz'
    sha256 'e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad'
  end

  def site_packages
    "#{link_lib}/python3.9/site-packages"
  end

  def export_env
    add_env 'PYTHONPATH', site_packages
  end

  def install
    CLI.error 'Use Clang compilers to build Python3!' if OS.mac? and CompilerSet.c.gcc?
    ENV['PYTHONHOME'] = nil
    ENV['PYTHONPATH'] = nil
    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --without-ensurepip
    ]
    unless CompilerSet.c.gcc? and CompilerSet.c.version <= '4.8.5'
      # Avoid error 'Could not import runpy module'
      args << '--enable-optimizations'
    end
    args << without_dtrace? ? '--without-dtrace' : '--with-dtrace'
    args << "--with-openssl=#{Openssl.prefix}" if not Openssl.skipped?
    if not Readline.skipped?
      inreplace 'setup.py',
        "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
        "do_readline = '#{Readline.link_lib}/libhistory.#{OS.soname}'"
    end
    if not Libffi.skipped?
      ENV['CPPFLAGS'] = "-I#{Libffi.common_inc}"
      ENV['LDFLAGS'] = "-L#{Libffi.common_lib} -L#{Libffi.common_lib64} -lffi"
    end
    run './configure', *args
    run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'install'
    # Install pip related tools.
    install_resource :setuptools, "#{libexec}/setuptools"
    install_resource :pip, "#{libexec}/pip", strip_leading_dirs: 1
    install_resource :wheel, "#{libexec}/wheel", strip_leading_dirs: 1
    mkdir site_packages
    ENV['PYTHONPATH'] = site_packages
    # Remove possible previous installed resouces.
    rm "#{site_packages}/setuptools*"
    rm "#{site_packages}/distribute*"
    rm "#{site_packages}/pip[-_.][0-9]*"
    rm "#{site_packages}/pip"
    setup_args = %W[
      -s setup.py
      --no-user-cfg
      install
      --force
      --verbose
      --single-version-externally-managed
      --record=installed.txt
      --install-scripts=#{bin}
      --install-lib=#{site_packages}
    ]
    append_ld_library_path lib
    work_in "#{libexec}/setuptools" do
      run "#{bin}/python3", 'bootstrap.py'
      run "#{bin}/python3", *setup_args
    end
    work_in "#{libexec}/pip" do
      run "#{bin}/python3", *setup_args
    end
    work_in "#{libexec}/wheel" do
      run "#{bin}/python3", *setup_args
    end
    rm "#{libexec}/setuptools"
    rm "#{libexec}/pip"
    rm "#{libexec}/wheel"
  end
end
