class Package
  include Utils
  include PackageDSL

  extend Forwardable
  def_delegators :@spec, :url, :mirror, :sha256, :file_name, :version, :group, :labels, :dependencies, :options, :labels

  def initialize
    package_class = self.class.name.split('::').last
    @spec = self.class.class_variable_get "@@#{package_class}_spec"
  end

  def self.prefix
    package_class = self.name.split('::').last
    spec = self.class_variable_get("@@#{package_class}_spec")
    if spec.group
      PackageLoader.loaded_packages[spec.group].prefix
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

  def include
    "#{Settings.link_root}/include"
  end

  def lib
    "#{Settings.link_root}/lib"
  end

  ['bin', 'include', 'lib', 'lib64'].each do |dir|
    define_method(:"opt_#{dir}") do
      "#{prefix}/#{dir}" if File.directory? "#{prefix}/#{dir}"
    end
  end

  def name
    self.class.name.split('::').last.gsub(/(.)([A-Z])/,'\1-\2').downcase.to_sym
  end

  def has_label? label_name
    @spec.labels.has_key? label_name
  end
end
