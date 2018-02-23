class Package
  include Utils
  include PackageDSL

  extend Forwardable
  def_delegators :@spec, :url, :mirror, :sha256, :file_name, :version, :group, :labels, :dependencies, :options
  def_delegators :@spec, :labels, :has_label?

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
    if spec.group
      PackageLoader.loaded_packages[spec.group].prefix
    elsif spec.has_label? :common
      "#{Settings.install_root}/common/Packages/#{package_class.gsub(/(.)([A-Z])/,'\1-\2').downcase}/#{spec.version}"
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

  [:bin, :include, :lib, :lib64].each do |dir|
    define_method(dir) do
      path = "#{prefix}/#{dir}"
      path if File.directory? path
    end
    define_method(:"link_#{dir}") do
      path = "#{Settings.link_root self}/#{dir}"
      path if File.directory? path
    end
    self.class.send :define_method, :"link_#{dir}" do
      path = "#{Settings.link_root}/#{dir}"
      path if File.directory? path
    end
    self.class.send :define_method, :"common_#{dir}" do
      path = "#{Settings.common_root}/#{dir}"
      path if File.directory? path
    end
  end

  def name
    self.class.name.split('::').last.gsub(/(.)([A-Z])/,'\1-\2').downcase.to_sym
  end
end
