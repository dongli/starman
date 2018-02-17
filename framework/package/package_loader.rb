module PackageLoader
  def self.loads package_names
    @@direct_packages = package_names
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
      load package_file_path(name, version)
      package = eval("#{name.to_s.split('-').collect(&:capitalize).join}").new
      @@loaded_packages[name] = package
      package.dependencies.each do |depend_name, depend_options|
        scan depend_name, depend_options[:version]
      end
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
    @@direct_packages.include? package.name
  end
end
