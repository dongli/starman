class Inteloneapi < Package
  version '2021.2.0'

  resource :base do
    url 'https://registrationcenter-download.intel.com/akdlm/irc_nas/17769/l_BaseKit_p_2021.2.0.2883_offline.sh'
    sha256 ''
  end

  resource :hpckit do
    url 'https://registrationcenter-download.intel.com/akdlm/irc_nas/17764/l_HPCKit_p_2021.2.0.2997_offline.sh'
    sha256 ''
  end

  def install
    ./install.sh --install-dir /opt/intel/oneapi --eula accept --intel-sw-improvement-program-consent decline --action install --components intel.oneapi.lin.tbb.devel:intel.oneapi.lin.ccl.devel:intel.oneapi.lin.ipp.devel:intel.oneapi.lin.mkl.devel --silent
  end
end
