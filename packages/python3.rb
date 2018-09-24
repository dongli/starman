class Python3 < Package
  url 'https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz'
  sha256 '0382996d1ee6aafe59763426cf0139ffebe36984474d0ec4126dd1c40a8b3549'

  label :common

  depends_on :readline
  depends_on :openssl
  depends_on :libffi

  option 'without-dtrace', 'Disable DTrace support.'

  resource :setuptools do
    url 'https://files.pythonhosted.org/packages/ef/1d/201c13e353956a1c840f5d0fbf0461bd45bbd678ea4843ebf25924e8984c/setuptools-40.2.0.zip'
    sha256 '47881d54ede4da9c15273bac65f9340f8929d4f0213193fa7894be384f2dcfa6'
  end

  resource :pip do
    url 'https://files.pythonhosted.org/packages/69/81/52b68d0a4de760a2f1979b0931ba7889202f302072cc7a0d614211bc7579/pip-18.0.tar.gz'
    sha256 'a0e11645ee37c90b40c46d607070c4fd583e2cd46231b1c06e389c5e814eed76'
  end

  resource :wheel do
    url 'https://files.pythonhosted.org/packages/2a/fb/aefe5d5dbc3f4fe1e815bcdb05cbaab19744d201bbc9b59cfa06ec7fc789/wheel-0.31.1.tar.gz'
    sha256 '0a2e54558a0628f2145d2fc822137e322412115173e8a2ddbe1c9024338ae83c'
  end

  def site_packages
    "#{link_lib}/python3.7/site-packages"
  end

  def export_env
    add_env 'PYTHONPATH', site_packages
  end

  def install
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
    install_resource :setuptools, libexec
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
    work_in "#{libexec}/setuptools-#{resource(:setuptools).version}" do
      run "#{bin}/python3", 'bootstrap.py'
      run "#{bin}/python3", *setup_args
    end
    work_in "#{libexec}/pip" do
      run "#{bin}/python3", *setup_args
    end
    work_in "#{libexec}/wheel" do
      run "#{bin}/python3", *setup_args
    end
    rm "#{libexec}/setuptools*"
    rm "#{libexec}/pip"
    rm "#{libexec}/wheel"
  end
end
