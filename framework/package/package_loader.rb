module PackageLoader
  def self.loads package_names
    @@loaded_packages = {}
    package_names.each do |package_name|
      next if package_name[0] == '-'
      scan package_name.to_sym
    end
    @@loaded_packages
  end

  def self.scan package_name
    return if @@loaded_packages.has_key? package_name
    if File.file? package_file_path(package_name)
      load package_file_path(package_name)
      package = eval("#{package_name.to_s.split('-').collect(&:capitalize).join}").new
      @@loaded_packages[package_name] = package
      package.dependencies.each do |depend_name, depend_options|
        scan depend_name
      end
    else
      CLI.error "Unknown package #{package_name}!"
    end
  end

  def self.package_file_path package_name
    "#{ENV['STARMAN_ROOT']}/packages/#{package_name}.rb"
  end
end
