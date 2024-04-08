class PackCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman pack <package_name>
EOS
    # Parse package names and load them.
    parse_packages relax: true
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
    tar_file = Gem::Package::TarWriter.new(File.open(tar_file_path, 'wb'))
    PackageLoader.loaded_packages.each do |name, package|
      unless package.has_label? :group
        if package.file_name
          CLI.blue_arrow package.file_path
          tar_file.add_file package.file_name, File.stat(package.file_path).mode do |io|
            io.write File.open(package.file_path, 'rb').read
          end
        end
        package.patches.each do |patch|
          next if patch.class == String
          CLI.blue_arrow patch.file_path
          tar_file.add_file patch.file_name, File.stat(patch.file_path).mode do |io|
            io.write File.open(patch.file_path, 'rb').read
          end
        end
        package.resources.each_value do |resource|
          CLI.blue_arrow resource.file_path
          tar_file.add_file resource.file_name, File.stat(resource.file_path).mode do |io|
            io.write File.open(resource.file_path, 'rb').read
          end
        end
      end
    end
    tar_file.close
    CLI.notice "Create #{CLI.blue tar_file_path}."
  end
end
