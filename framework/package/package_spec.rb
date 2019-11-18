# PackageSpec store specifications of a package.

class PackageSpec
  def initialize
    @url = nil
    @mirror = nil
    @sha256 = nil
    @version = nil
    @file_name = nil
    @group = nil
    @labels = {}
    @dependencies = {}
    @options = {}
    @patches = []
    @conflicts = []
    @resources = {}
    @links = {}
  end

  def url val = nil
    return @url unless val
    @url = val
    self.file_name = File.basename(URI.parse(val).path)
  end
  def url= val
    @url = val
    self.file_name = File.basename(URI.parse(val).path)
  end

  [:mirror, :sha256, :version, :group].each do |attr|
    define_method(attr) do |val = nil|
      return self.instance_variable_get :"@#{attr}" unless val
      self.instance_variable_set :"@#{attr}", val
    end
  end
  attr_writer :mirror, :sha256, :version, :group

  def version= val
    begin
      @version = Version.new val, raise_exception: true
    rescue
      @version = val
    end
  end

  def file_name val = nil
    return @file_name unless val
    @file_name = val
    # Assume a reasonable file name pattern to extract version information.
    match = /.*-(\d+\.\d+(\.\d+(\.\d+)?)?)/.match(val)
    self.version = match[1] if match
  end
  def file_name= val
    @file_name = val
    # Assume a reasonable file name pattern to extract version information.
    match = /.*-(\d+\.\d+(\.\d+(\.\d+)?)?)/.match(val)
    self.version = match[1] if match
  end
  def file_path
    Settings.cache_root + '/' + file_name
  end

  attr_reader :labels
  def label val, options = {}
    @labels[val] = options
  end
  def has_label? val
    @labels.has_key? val
  end

  attr_accessor :dependencies
  def depends_on val, options = {}
    @dependencies[val.to_sym] = options
  end

  attr_accessor :options
  def option val, options = {}
    @options[val] ||= options
  end

  attr_reader :resources
  def resource name, spec = nil
    @resources[name.to_sym] = spec if spec
    @resources[name.to_sym]
  end

  attr_reader :patches
  def patch options=nil, &block
    if options.class == String
      @patches << options
    else
      spec = PackageSpec.new
      spec.instance_exec &block
      return if @patches.any? { |patch| patch.sha256 == spec.sha256 }
      spec.options = options if options.class == Hash
      @patches << spec
    end
  end

  attr_reader :conflicts
  def conflicts_with *vals
    vals.each do |val|
      @conflicts << val.to_sym unless @conflicts.include? val.to_sym
    end
  end

  attr_reader :links
  def link src, dst
    @links[src] = dst
  end

  attr_accessor :system_prefix
end
