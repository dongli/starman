class InstallCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman install <package_name> ... [options]
EOS
    # Parse package names and load them.
    parse_packages
    # Define options.
    @parser.on '-cNAME', '--compiler-set NAME', 'Set the active compiler set by its name set in conf file.' do |compiler_set|
      @@args[:compiler_set] = compiler_set
    end
    @parser.on '-k', '--skip-test', 'Skip possible build test (e.g., make test)' do
      @@args[:skip_test] = true
    end    
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

  def link package
    regex = /#{package.prefix}\/?(.*)/
    Dir.glob("#{package.prefix}/**/*").each do |file_path|
      next if File.directory? file_path
      basename = File.basename file_path
      subdir = File.dirname(file_path).match(regex)[1]
      dir = "#{Settings.link_root}/#{subdir}"
      # Fix 'libtool: warning: library XXX was moved.' problem.
      inreplace file_path, /^libdir='.*'$/, "libdir='#{dir}'" if basename =~ /.*\.la$/
      FileUtils.mkdir_p dir if not File.directory? dir
      FileUtils.ln_sf file_path, "#{dir}/#{basename}"
    end
  end

  def run
    PackageLoader.loaded_packages.each do |name, package|
      if package.has_label? :skip_if_exist
        if package.labels[:skip_if_exist].has_key? :file and File.file? package.labels[:skip_if_exist][:file]
          CLI.notice "Use system #{CLI.green name}."
          next
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
            package.install
          end
        end
        FileUtils.rm_rf dir
        link package
        History.save_install package
        CLI.notice "Package #{CLI.green package.name}@#{CLI.blue package.version} is installed at #{CLI.blue package.prefix}."
      end
    end
  end
end
