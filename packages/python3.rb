class Python3 < Package
  url 'https://www.python.org/ftp/python/3.8.6/Python-3.8.6.tar.xz'
  sha256 'a9e0b79d27aa056eb9cce8d63a427b5f9bab1465dee3f942dcfdb25a82f4ab8a'

  label :skip_if_exist, binary_file: 'python3'

  label :common

  depends_on :readline
  depends_on :zlib
  depends_on :openssl
  depends_on :libffi

  option 'without-dtrace', 'Disable DTrace support.'

  resource :setuptools do
    url 'https://files.pythonhosted.org/packages/7c/1b/9b68465658cda69f33c31c4dbd511ac5648835680ea8de87ce05c81f95bf/setuptools-50.3.0.zip'
    sha256 '39060a59d91cf5cf403fa3bacbb52df4205a8c3585e0b9ba4b30e0e19d4c4b18'
  end

  resource :pip do
    url 'https://files.pythonhosted.org/packages/59/64/4718738ffbc22d98b5223dbd6c5bb87c476d83a4c71719402935170064c7/pip-20.2.3.tar.gz'
    sha256 '30c70b6179711a7c4cf76da89e8a0f5282279dfb0278bec7b94134be92543b6d'
  end

  resource :wheel do
    url 'https://files.pythonhosted.org/packages/83/72/611c121b6bd15479cb62f1a425b2e3372e121b324228df28e64cc28b01c2/wheel-0.35.1.tar.gz'
    sha256 '99a22d87add3f634ff917310a3d87e499f19e663413a52eb9232c447aa646c9f'
  end

  def site_packages
    "#{link_lib}/python3.8/site-packages"
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
      --with-openssl=#{Openssl.prefix}
      --enable-optimizations
    ]
    args << without_dtrace? ? '--without-dtrace' : '--with-dtrace'
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
    run 'make'
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
