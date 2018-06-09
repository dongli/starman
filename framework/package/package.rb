class Package
  include Utils
  include PackageDSL

  extend Forwardable
  def_delegators :@spec, :url, :url=, :mirror, :sha256, :file_name, :version, :group, :labels, :dependencies, :options
  def_delegators :@spec, :labels, :has_label?, :conflicts, :resources, :resource, :links

  def initialize
    package_class = self.class.name.split('::').last
    @spec = self.class.class_variable_get "@@#{package_class}_spec"
    # Check necessary attributes are set.
    [:version].each do |attr|
      CLI.error "Package #{CLI.red name} lacks attribute #{CLI.blue attr}!" if not @spec.send(attr)
    end
  end

  def self.prefix
    package_class = self.name.split('::').last
    spec = self.class_variable_get("@@#{package_class}_spec")
    name = package_class.gsub(/(.)([A-Z])/,'\1-\2').downcase
    if spec.group
      PackageLoader.loaded_packages[spec.group].prefix
    elsif spec.has_label? :common
      "#{Settings.install_root}/common/Packages/#{name}/#{spec.version}"
    elsif spec.has_label? :compiler
      "#{Settings.install_root}/#{name}_#{spec.version}/Packages/#{name}/#{spec.version}"
    else
      "#{Settings.install_root}/#{Settings.compiler_set}/Packages/#{package_class.gsub(/(.)([A-Z])/,'\1-\2').downcase}/#{spec.version}"
    end
  end

  def prefix
    self.class.prefix
  end

  def install_root
    Settings.link_root
  end

  def link_root
    Settings.link_root self
  end
  def self.link_root
    self.new.link_root
  end

  [:bin, :inc, :lib, :lib64, :man].each do |dir|
    define_method(dir) do
      dir = dir == :inc ? :include : dir
      dir = dir == :man ? 'share/man' : dir
      "#{prefix}/#{dir}"
    end
    define_method(:"link_#{dir}") do
      dir = dir == :inc ? :include : dir
      dir = dir == :man ? 'share/man' : dir
      "#{Settings.link_root self}/#{dir}"
    end
    define_method(:"common_#{dir}") do
      dir = dir == :inc ? :include : dir
      dir = dir == :man ? 'share/man' : dir
      "#{Settings.common_root}/#{dir}"
    end
    self.class.send :define_method, dir do
      dir = dir == :inc ? :include : dir
      dir = dir == :man ? 'share/man' : dir
      "#{prefix}/#{dir}"
    end
    self.class.send :define_method, :"link_#{dir}" do
      dir = dir == :inc ? :include : dir
      dir = dir == :man ? 'share/man' : dir
      "#{Settings.link_root}/#{dir}"
    end
    self.class.send :define_method, :"common_#{dir}" do
      dir = dir == :inc ? :include : dir
      dir = dir == :man ? 'share/man' : dir
      "#{Settings.common_root}/#{dir}"
    end
  end

  def name
    self.class.name.split('::').last.gsub(/(.)([A-Z])/,'\1-\2').downcase.to_sym
  end

  def install_resource name, dir, options = {}
    FileUtils.mkdir_p dir if not Dir.exist? dir
    if options[:plain_file]
      FileUtils.cp "#{Settings.cache_root}/#{resource(name).file_name}", dir
    else
      work_in dir do
        decompress "#{Settings.cache_root}/#{resource(name).file_name}", options
      end
    end
  end

  # Default actions.
  def post_install
  end

  def export_env
  end
end
