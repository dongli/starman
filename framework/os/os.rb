class OS
  include OsDSL

  extend Forwardable
  def_delegators :@spec, :type, :version

  def initialize
    @spec = self.class.class_variable_get "@@#{self.class}_spec"
    @spec.eval
  end

  def self.init
    case `uname`.strip.to_sym
    when :Darwin
      @@os = Mac.new
    else
      CLI.error "Unknown OS #{CLI.red `uname`.strip}!"
    end
  end

  def self.mac?
    @@os.type == :mac
  end

  def self.linux?
    [:centos].include? @@os.type
  end

  def self.ld_library_path
    mac? ? 'DYLD_LIBRARY_PATH' : 'LD_LIBRARY_PATH'
  end
end
