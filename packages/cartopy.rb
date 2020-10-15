class Cartopy < Package
  url 'https://pypi.tuna.tsinghua.edu.cn/packages/46/c1/04e50c9986842f00f7db0e7a65caa896840050d7328f74e5b7437aa01179/Cartopy-0.18.0.tar.gz'
  sha256 '7ffa317e8f8011e0d965a3ef1179e57a049f77019867ed677d49dcc5c0744434'

  label :common

  depends_on :proj
  depends_on :geos
  depends_on :python3

  resource :shapely do
    url 'https://pypi.tuna.tsinghua.edu.cn/packages/42/f3/0e1bc2c4f15e05e30c6b99322b9ddaa2babb3f43bc7df2698efdc1553439/Shapely-1.7.1.tar.gz'
    sha256 '1641724c1055459a7e2b8bbe47ba25bdc89554582e62aec23cb3f3ca25f9b129'
  end

  resource :pyshp do
    url 'https://pypi.tuna.tsinghua.edu.cn/packages/ca/1f/e9cc2c3fce32e2926581f8b6905831165235464c858ba550b6e9b8ef78c3/pyshp-2.1.2.tar.gz'
    sha256 'a0aa668cd0fc09b873f10facfe96971c0496b7fe4f795684d96cc7306ac5841c'
  end

  def install
    site_packages = "python#{Version.new(`python3 --version`.split[1]).major_minor}/site-packages"
    ENV['PYTHONPATH'] = "#{lib64}/#{site_packages}:#{lib}/#{site_packages}"
    install_resource :shapely, '.'
    work_in 'shapely' do
      run 'python3', 'setup.py', 'install', "--prefix=#{prefix}"
    end
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
