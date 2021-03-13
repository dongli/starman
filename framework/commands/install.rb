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
    @parser.on '--keep-path', 'Keep environment variable PATH.' do
      @@args[:keep_path] = true
    end
    @parser.on '-aNAME', '--http-cache NAME', 'Set a HTTP cache to get packages.' do |http_cache|
      @@args[:http_cache] = http_cache
    end
    @parser.on '-k', '--skip-test', 'Skip possible build test (e.g., make test).' do
      @@args[:skip_test] = true
    end    
    @parser.on '-j', '--make-jobs NUMBER', 'Set the number of making jobs (currently only works for hdf5 and netcdf).' do |make_jobs|
      @@args[:make_jobs] = make_jobs
    end
    @parser.on '-f', '--force', 'Install packages anyway.' do
      @@args[:force] = true
    end
    # Parse package names and load them.
    parse_packages
    # Add possible package option and parse.
    PackageLoader.loaded_packages.each_value do |package|
      package.options.each do |name, option|
        case option[:type]
        when :boolean
          @parser.on "--#{name.to_s.gsub('_', '-')}", option[:desc] do
            option[:value] = true
          end
        else
          @parser.on "--#{name.to_s.gsub('_', '-')} VALUE", "#{option[:desc]}#{' (' + option[:choices].join(', ') + ')' if option.has_key? :choices}" do |value|
            if option[:choices] and not option[:choices].include? value
              CLI.error "Invalid value #{CLI.red value} for argument #{CLI.blue '--' + name.to_s.gsub('_', '-')}! Choose one of #{option[:choices]}."
            end
            option[:value] = value
          end
        end
      end
    end
    @parser.parse!
    # Reparse packages because the command options may change dependencies.
    parse_packages force: true
    # Load GCC installed by STARMAN if necessary.
    PackageLoader.loads [:gcc] if CompilerSet.needs_load?
    # Reinitialize settings since compiler set may be set in command line.
    Settings.init
    CompilerSet.init
  end

  def run
    # Clean up system environment to avoid possible pollution.
    if not CommandParser.args[:keep_path]
      clean_path = []
      ENV['PATH'].split(':').each do |path|
        if path.include? Settings.install_root and not clean_path.include? path
          clean_path << path
        end
      end
      clean_path << '/usr/local/bin' << '/bin' << '/usr/bin' << '/sbin'
      ENV['PATH'] = clean_path.join(':')
    end
    if CompilerSet.c.command.include?('Packages/gcc')
      PackageLoader.loads ['gcc']
      gcc = PackageLoader.loaded_packages[:gcc]
      PackageLoader.loaded_packages.delete :gcc
      load_package gcc
    end
    PackageLoader.loaded_packages.each do |name, package|
      if package.has_label? :skip_if_exist and not (PackageLoader.from_cmd_line?(package) and CommandParser.args[:force])
        if package.skipped?
          CLI.notice "Use system #{CLI.green name}."
          next
        end
      end
      res = History.installed? package
      if package.has_label? :group
        CLI.notice "Package group #{CLI.green package.name}@#{CLI.blue package.version} is installed."
      elsif res == true
        CLI.notice "Package #{CLI.green package.name}@#{CLI.blue package.version} has been installed."
      elsif res == :old_version_installed
        if package.from_cmd_line?
          CLI.warning "Package #{CLI.blue package.name} #{CLI.red package.version} has been installed! Use --force/-f to override."
        end
      else
        if res == :old_version_installed_but_unlink_it
          CLI.notice "Unlink package #{CLI.green package.name} ..."
          PackageLinker.unlink package
        end
        package.resources.each_value do |resource|
          PackageDownloader.download resource
        end
        PackageDownloader.download package
        CLI.notice "Install package #{CLI.green package.name}@#{CLI.blue package.version} ..."
        dir = "#{Settings.cache_root}/#{package.name}_#{Settings.compiler_set}"
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
            # Apply possible patches.
            package.patches.each_with_index do |patch, index|
              CLI.notice "Apply patch #{CLI.green index.to_s} to #{CLI.blue package.name}."
              case patch
              when String
                patch_data patch
              when PackageSpec
                patch_file "#{Settings.cache_root}/#{patch.file_name}", patch.options
              else
                CLI.error 'Unprocessed patch!'
              end
            end
            set_compile_flags package
            package.install
            package.post_install
          end
        end
        FileUtils.rm_rf dir
        PackageLinker.link package unless package.has_label? :alone
        History.save_install package
        CLI.notice "Package #{CLI.green package.name}@#{CLI.blue package.version} is installed at #{CLI.blue package.prefix}."
      end
      # Change environment to affect following packages.
      append_path package.bin if package.bin
      append_pkg_config_path package.lib + '/pkgconfig'
      if not package.has_label? :conflict_with_system
        append_ld_library_path package.lib if Dir.exist? package.lib
        append_ld_library_path package.lib64 if Dir.exist? package.lib64
      end
      package.export_env
      added_env.each { |key, val| ENV[key] = val }
      appended_env.each { |key, val| ENV[key] = val }
    end
  end
end
