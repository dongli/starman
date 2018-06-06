class PackCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman pack <package_name>
EOS
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
    Settings.init
  end

  def run
    PackageLoader.loaded_packages.each do |name, package|
      unless package.has_label? :group
        package.resources.each_value do |resource|
          PackageDownloader.download resource
        end
        PackageDownloader.download package
      end
    end
    tar_file_path = "/tmp/starman-packages-#{DateTime.now.strftime('%Y%m%d%H%M%S')}.tar"
    tar_file = Gem::Package::TarWriter.new(File.open(tar_file_path, 'w'))
    PackageLoader.loaded_packages.each do |name, package|
      unless package.has_label? :group
        CLI.blue_arrow package.file_path
        content = File.open(package.file_path, 'rb').read
        tar_file.add_file_simple package.file_name, 0444, content.length { |io| io.write content }
      end
    end
    tar_file.close
    CLI.notice "Create #{CLI.blue tar_file_path}."
  end
end
