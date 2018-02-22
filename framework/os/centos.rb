class CentOS < OS
  type :centos

  version do
    # CentOS Linux release 7.4.1708 (Core)
    `cat /etc/centos-release`.match(/CentOS Linux release ([\d\.]+)/)[1]
  end
end
