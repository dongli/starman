class Cartopy < Package
  url 'https://pypi.tuna.tsinghua.edu.cn/packages/46/c1/04e50c9986842f00f7db0e7a65caa896840050d7328f74e5b7437aa01179/Cartopy-0.18.0.tar.gz'
  sha256 '7ffa317e8f8011e0d965a3ef1179e57a049f77019867ed677d49dcc5c0744434'

  label :common

  depends_on :proj
  depends_on :geos

  resource :pyshp do
    url 'https://pypi.tuna.tsinghua.edu.cn/packages/27/16/3bf15aa864fb77845fab8007eda22c2bd67bd6c1fd13496df452c8c43621/pyshp-2.1.0.tar.gz'
    sha256 'e65c7f24d372b97d0920b864bbeb78322bb37b83f2606e2a2212631d5d51e5c0'
  end

  def install
    site_packages = "python#{Version.new(`python3 --version`.split[1]).major_minor}/site-packages"
    ENV['PYTHONPATH'] = "#{lib64}/#{site_packages}:#{lib}/#{site_packages}"
    install_resource :pyshp, '.'
    work_in 'pyshp' do
      run 'python3', 'setup.py', 'install', "--prefix=#{prefix}"
    end
    args = %W[
      -I#{Proj.inc}
      -I#{Geos.inc}
      -L#{Proj.lib}
      -L#{Geos.lib}
    ]
    run 'python3', 'setup.py', 'build_ext', *args
    run 'python3', 'setup.py', 'install', "--prefix=#{prefix}"
    CLI.caveat "Add export PYTHONPATH=#{ENV['PYTHONPATH']}:$PYTHONPATH into your ~/.bashrc!"
  end
end
