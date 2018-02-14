class Package
  include PackageDSL

  extend Forwardable
  def_delegators :@spec, :url, :mirror, :sha256, :file_name, :version, :labels, :dependencies, :options, :labels

  def initialize
    @spec = self.class.class_variable_get "@@#{self.class}_spec"
  end

  def self.prefix
    "#{Settings.install_root}/#{Settings.compiler_set}/Packages/#{self.name.gsub(/(.)([A-Z])/,'\1-\2').downcase}/#{self.class_variable_get("@@#{self}_spec").version}"
  end

  def prefix
    self.class.prefix
  end

  def install_root
    Settings.link_root
  end

  def run cmd, *options
    cmd_line = "#{cmd} #{options.select { |option| option.class == String }.join(' ')}"
    system cmd_line
    CLI.error "Failed to run #{cmd_line}!" if not $?.success?
  end

  def name
    self.class.name.gsub(/(.)([A-Z])/,'\1-\2').downcase
  end
end
