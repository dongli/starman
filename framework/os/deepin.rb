class Deepin < OS
  type :deepin

  version do
    # VERSION="15.11"
    # DISTRIB_RELEASE=15.11
    `cat /etc/os-release`.match(/(VERSION|RELEASE)="?(\d+[\.\d+]*)/)[2]
  end

  command :add_user do |name, options = {}|
    if options[:all_nodes]
      uid = []
      Settings.nodes.each do |node|
        # First check if user exists.
        next if ssh("id #{name} 2>&1", host: node, user: 'root')[:status].success?
        # Then we can add user in each node.
        args = []
        if options[:system_user]
          args << '--system'
          args << '--no-create-home'
        end
        if not ssh("useradd #{args.join(' ')} #{name} 2>&1", host: node, user: 'root')[:status].success?
          # Try to delete already added user.
          delete_user name, options
          CLI.error "Failed to add user #{CLI.blue name} on node #{CLI.red node}!"
        end
        # Record uid for later check.
        res = ssh("id #{name} 2>&1", host: node, user: 'root')[:output]
        uid << res.match(/uid=(\d+)/)[1]
        CLI.notice "Add user #{CLI.blue name} on node #{CLI.green node} with uid #{uid.last}."
      end
      # Check if uid is the same across nodes.
      if uid.uniq.size > 1
        CLI.error "Add user #{CLI.blue name} successfully, but uids are not all the same!"
      end
    else
      CLI.error 'Under construction!'
    end
  end

  command :delete_user do |name, options = {}|
    if options[:all_nodes]
      Settings.nodes.each do |node|
        # First check if user exists.
        next unless ssh("id #{name} 2>&1", host: node, user: 'root')[:status].success?
        args = %W[--selinux-user]
        if not ssh("userdel #{args.join(' ')} #{name} 2>&1", host:node, user: 'root')[:status].success?
          CLI.error "Failed to delete user #{CLI.blue name} on host #{CLI.red node}!"
        end
        CLI.notice "Delete user #{CLI.blue name} on node #{CLI.green node}."
      end
    else
      CLI.error 'Under construction!'
    end
  end
end
