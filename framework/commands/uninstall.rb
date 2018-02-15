class UninstallCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman uninstall <package_name> ... [options]
EOS
    @parser.on '--with-deps', 'Also uninstall dependency packages.' do
      @@args[:with_deps] = true
    end
    # Parse package names and load them.
    @packages = PackageLoader.loads ARGV.select { |arg| arg[0] != '-' }
    @parser.parse!
  end

  def unlink package
    regex = /#{package.prefix}\/?(.*)/
    Dir.glob("#{package.prefix}/**/*").each do |file_path|
      next if File.directory? file_path
      basename = File.basename file_path
      subdir = File.dirname(file_path).match(regex)[1]
      dir = "#{Settings.link_root}/#{subdir}"
      FileUtils.rm_f "#{dir}/#{basename}"
      # Remove empty directory.
      FileUtils.rmdir dir if Dir.glob("#{dir}/*").size == 0
    end
  end

  def run
    @packages.keys.each do |package_name|
      package = @packages[package_name]
      next if not PackageLoader.from_cmd_line? package and not CommandParser.args[:with_deps]
      if not History.installed? package
        CLI.warning "Package #{CLI.green package_name} has not been installed."
      else
        CLI.notice "Uninstall package #{CLI.green package_name} ..."
        unlink package
        FileUtils.rm_rf package.prefix
        # Remove empty directory.
        FileUtils.rmdir File.dirname(package.prefix) if Dir.glob("#{File.dirname(package.prefix)}/*").size == 0
        History.remove_install package
      end
    end
  end
end