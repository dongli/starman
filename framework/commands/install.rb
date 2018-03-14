class InstallCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman install <package_name> ... [options]
EOS
    # Define options.
    @parser.on '-cNAME', '--compiler-set NAME', 'Set the active compiler set by its name set in conf file.' do |compiler_set|
      @@args[:compiler_set] = compiler_set
    end
    @parser.on '-k', '--skip-test', 'Skip possible build test (e.g., make test)' do
      @@args[:skip_test] = true
    end    
    @parser.on '-f', '--force', 'Install packages anyway' do
      @@args[:force] = true
    end
    # Parse package names and load them.
    parse_packages
    # Add possible package option and parse.
    PackageLoader.loaded_packages.each_value do |package|
      package.options.each do |name, option|
        @parser.on "--#{name.to_s.gsub('_', '-')}", option[:desc] do
          option[:value] = true
        end
      end
    end
    @parser.parse!
  end

  def run
    PackageLoader.loaded_packages.each do |name, package|
      if package.has_label? :skip_if_exist
        if package.labels[:skip_if_exist].has_key? :file and File.file? package.labels[:skip_if_exist][:file]
          CLI.notice "Use system #{CLI.green name}."
          next
        elsif package.labels[:skip_if_exist].has_key? :version
          v = Version.new(package.labels[:skip_if_exist][:version].call)
          next if v.compare(package.labels[:skip_if_exist][:condition])
        end
      end
      if package.has_label? :group
        CLI.notice "Package group #{CLI.green package.name}@#{CLI.blue package.version} is installed."
      elsif History.installed? package
        CLI.notice "Package #{CLI.green package.name}@#{CLI.blue package.version} has been installed."
      else
        PackageDownloader.download package
        CLI.notice "Install package #{CLI.green package.name}@#{CLI.blue package.version} ..."
        dir = "#{Settings.cache_root}/#{package.name}"
        FileUtils.rm_rf dir if File.directory? dir
        FileUtils.mkdir_p dir
        work_in dir do
          decompress "#{Settings.cache_root}/#{package.file_name}"
          subdirs = Dir.glob('*')
          if subdirs.size > 1
            working_dir = dir
            CLI.warning "There are multiple directories in #{CLI.red dir}."
          else
            working_dir = subdirs.first
          end
          work_in working_dir do
            set_compile_flags package
            package.install
          end
        end
        FileUtils.rm_rf dir
        PackageLinker.link package
        History.save_install package
        CLI.notice "Package #{CLI.green package.name}@#{CLI.blue package.version} is installed at #{CLI.blue package.prefix}."
      end
      # Change environment to affect following packages.
      append_path package.bin if package.bin
      append_ld_library_path package.lib if package.lib
    end
  end
end
