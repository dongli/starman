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
    @parser.on '-k', '--skip-test', 'Skip possible build test (e.g., make test).' do
      @@args[:skip_test] = true
    end    
    @parser.on '-j', '--make-jobs', 'Set the number of make jobs.' do |make_jobs|
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
          @parser.on "--#{name.to_s.gsub('_', '-')} VALUE", option[:desc] do |value|
            if option[:choices] and not option[:choices].include? value
              CLI.error "Invalid value #{CLI.red value} for argument #{CLI.blue '--' + name.to_s.gsub('_', '-')}! Choose one of #{option[:choices]}."
            end
            option[:value] = value
          end
        end
      end
    end
    @parser.parse!
    @@args[:make_jobs] ||= 2
    # Reinitialize settings since compiler set may be set in command line.
    Settings.init
    CompilerSet.init
  end

  def run
    if CompilerSet.c.command.include?('Packages/gcc')
      PackageLoader.loads 'gcc'
      gcc = PackageLoader.loaded_packages[:gcc]
      PackageLoader.loaded_packages.delete :gcc
      append_ld_library_path gcc.lib if Dir.exist? gcc.lib
      append_ld_library_path gcc.lib64 if Dir.exist? gcc.lib64
      gcc.export_env
    end
    PackageLoader.loaded_packages.each do |name, package|
      if package.has_label? :skip_if_exist and not CommandParser.args[:force]
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
        CLI.warning "Package #{CLI.blue package.name} #{CLI.red package.version} has been installed! Use --force/-f to override."
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
                patch_file "#{Settings.cache_root}/#{patch.file_name}"
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
      if not package.has_label? :conflict_with_system
        append_ld_library_path package.lib if Dir.exist? package.lib
        append_ld_library_path package.lib64 if Dir.exist? package.lib64
      end
      package.export_env
    end
  end
end
