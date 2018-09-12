module PackageLoader
  def self.loaded_packages
    @@loaded_packages
  end

  def self.loads *package_names
    @@direct_packages = package_names.map &:to_sym
    @@loaded_packages ||= {}
    package_names.each do |package_name|
      # package_name may be in <name>@<version> form.
      name, version = package_name.to_s.split '@'
      name = name.to_sym
      scan name, version: version
    end
    @@loaded_packages
  end

  def self.scan name, options = {}
    return if @@loaded_packages.has_key? name
    if package_file_path(name, options[:version])
      eval open(package_file_path(name, options[:version]), 'r').read
      package = eval("#{name.to_s.split('-').collect(&:capitalize).join}").new
      if not options[:nodeps] and not package.skipped?
        package.dependencies.keys.each do |depend_name|
          depend_package = scan depend_name, package.dependencies[depend_name]
          if depend_package and depend_package.name != depend_name
            package.dependencies[depend_package.name] = {}
            package.dependencies.delete depend_name
          elsif not depend_package
            package.dependencies.delete depend_name
          end
        end
      end
      scan package.group, nodeps: true if package.group
      @@loaded_packages[name] = package
    else
      return if PackageSpecialLabels.check name
      possible_packages = []
      search_packages_for_label(name).each do |path|
        eval open(path, 'r').read
        name = File.basename(path, '.rb')
        possible_packages << eval("#{name.to_s.split('-').collect(&:capitalize).join}").new
        if History.installed? possible_packages.last
          return scan(possible_packages.last.name)
        end
      end
      if possible_packages.size > 1
        CLI.error "You should install one of #{possible_packages.map(&:name).join(', ')} first!"
      elsif possible_packages.size == 0
        CLI.error "Unknown input #{CLI.red name}!"
      else
        scan name
        @@loaded_packages[name].version = options[:version] if options[:version]
      end
    end
  end

  def self.package_file_path name, version
    path = "#{ENV['STARMAN_ROOT']}/packages/#{name.to_s.gsub('_', '-')}#{version ? '@' + version : ''}.rb"
    if not File.file? path
      path = "#{ENV['STARMAN_ROOT']}/packages/#{name.to_s.gsub('_', '-')}.rb"
      path = nil unless File.file? path and (version and open(path).read.match(version))
    end
    return path
  end

  def self.from_cmd_line? package
    @@direct_packages.include? package.name or @@direct_packages.include? :"#{package.name}@#{package.version}" or
    @@direct_packages.any? do |package_name|
      name, version = package_name.to_s.split '@'
      name = name.to_sym
      loaded_package = @@loaded_packages[name]
      loaded_package.dependencies.has_key? package.name and loaded_package.has_label? :group
    end
  end

  def self.search_packages_for_label label
    matches = []
    Dir.glob("#{ENV['STARMAN_ROOT']}/packages/*.rb").each do |path|
      matches << path if open(path, 'r').read =~ /label :#{label}/
    end
    return matches
  end
end
