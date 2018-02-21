module PackageLoader
  def self.loaded_packages
    @@loaded_packages
  end

  def self.loads package_names
    @@direct_packages = package_names.map &:to_sym
    @@loaded_packages = {}
    package_names.each do |package_name|
      # package_name may be in <name>@<version> form.
      name, version = package_name.split '@'
      name = name.to_sym
      scan name, version
    end
    @@loaded_packages
  end

  def self.scan name, version
    return if @@loaded_packages.has_key? name
    if File.file? package_file_path(name, version)
      eval open(package_file_path(name, version), 'r').read
      package = eval("#{name.to_s.split('-').collect(&:capitalize).join}").new
      package.dependencies.each do |depend_name, depend_options|
        scan depend_name, depend_options[:version]
      end
      @@loaded_packages[name] = package
    else
      CLI.error "Unknown package #{CLI.red name}#{version ? '@' + version : ''}!"
    end
  end

  def self.package_file_path name, version
    path = "#{ENV['STARMAN_ROOT']}/packages/#{name}#{version ? '-' + version : ''}.rb"
    if not File.file? path
      path = "#{ENV['STARMAN_ROOT']}/packages/#{name}.rb"
      path = nil unless File.file? path and open(path).read.match(version)
    end
    return path
  end

  def self.from_cmd_line? package
    @@direct_packages.include? package.name or @@direct_packages.any? do |name|
      loaded_package = @@loaded_packages[name]
      loaded_package.dependencies.has_key? package.name and loaded_package.has_label? :group
    end
  end
end
