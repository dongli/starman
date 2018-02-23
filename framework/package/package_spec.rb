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
  end

  attr_reader :url
  def url= val
    @url = val
    self.file_name = File.basename(URI.parse(val).path)
  end

  attr_accessor :mirror, :sha256, :version, :group

  attr_reader :file_name
  def file_name= val
    @file_name = val
    # Assume a reasonable file name pattern to extract version information.
    match = /.*-(\d+\.\d+(\.\d+(\.\d+)?)?)/.match(val)
    @version = match[1] if match
  end

  attr_reader :labels
  def label val, options = {}
    @labels[val] = options
  end
  def has_label? val
    @labels.has_key? val
  end

  attr_reader :dependencies
  def depends_on val, options = {}
    @dependencies[val.to_sym] = options
  end

  attr_reader :options
  def option val, options = {}
    @options[val] = options
  end

  attr_reader :patches
  def patch data = nil, &block
    if data
      @patches << data
    else
      spec = PackageSpec.new
      spec.instance_exec &block
      @patches << spec
    end
  end
end
