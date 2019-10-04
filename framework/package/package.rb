class Package
  include Utils
  include PackageDSL

  extend Forwardable
  def_delegators :@spec, :url, :url=, :mirror, :sha256, :file_name, :file_path, :version, :version=
  def_delegators :@spec, :group, :labels, :dependencies, :options, :patches
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
    elsif spec.has_label? :skip_if_exist and spec.system_prefix
      spec.system_prefix
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

  def self.has_label? label
    package_class = self.name.split('::').last
    spec = self.class_variable_get("@@#{package_class}_spec")
    spec.has_label? label
  end

  def install_root
    Settings.link_root
  end

  def link_root
    Settings.link_root self
  end
  def self.link_root
    if self == Package
      "#{Settings.install_root}/#{Settings.compiler_set}"
    else
      self.new.link_root
    end
  end

  [:bin, :inc, :lib, :lib64, :libexec, :share, :man].each do |dir|
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
      "#{Settings.link_root self}/#{dir}"
    end
    self.class.send :define_method, :"common_#{dir}" do
      dir = dir == :inc ? :include : dir
      dir = dir == :man ? 'share/man' : dir
      "#{Settings.common_root}/#{dir}"
    end
  end

  def self.package_name package_class
    package_class.name.split('::').last.gsub(/(.)([A-Z])/,'\1-\2').downcase.to_sym
  end
  def name
    Package.package_name self.class
  end

  def install_resource name, dir, options = {}
    dir += '/' + name.to_s if dir == '.'
    FileUtils.mkdir_p dir if not Dir.exist? dir
    if options[:plain_file]
      FileUtils.cp "#{Settings.cache_root}/#{resource(name).file_name}", dir
    else
      work_in dir do
        decompress "#{Settings.cache_root}/#{resource(name).file_name}", options.merge(strip_leading_dirs: 1)
      end
    end
  end

  def self.skipped?
    instance = self.new
    instance.skipped?
  end
  def skipped?
    return true if self.has_label? :conflict_with_system
    return false unless self.has_label? :skip_if_exist
    if self.labels[:skip_if_exist].has_key? :file and File.file? self.labels[:skip_if_exist][:file]
      return true
    elsif self.labels[:skip_if_exist].has_key? :binary_file
      return !which(self.labels[:skip_if_exist][:binary_file]).empty?
    elsif self.labels[:skip_if_exist].has_key? :include_file
      ['/usr/include', '/usr/local/include'].each do |dir|
        if File.file? "#{dir}/#{self.labels[:skip_if_exist][:include_file]}"
          @spec.system_prefix = File.dirname dir
          return true
        end
      end
    elsif self.labels[:skip_if_exist].has_key? :library_file
      ['/usr/lib', '/usr/lib64', '/usr/local/lib', '/usr/local/lib64'].each do |dir|
        if File.file? "#{dir}/#{self.labels[:skip_if_exist][:library_file]}"
          @spec.system_prefix = File.dirname dir
          return true
        end
      end
    elsif self.labels[:skip_if_exist].has_key? :version
      v = Version.new(self.labels[:skip_if_exist][:version].call)
      return true if v.compare(self.labels[:skip_if_exist][:condition])
    end
    return false
  end

  def from_cmd_line?
    PackageLoader.from_cmd_line? self
  end

  # Default actions.
  def post_install
  end

  def export_env
  end
end
