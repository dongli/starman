class OS
  extend Utils
  include OsDSL

  extend Forwardable
  def_delegators :@spec, :type, :version, :commands

  def initialize
    @spec = self.class.class_variable_get "@@#{self.class}_spec"
    @spec.eval
  end

  def self.init
    sys = `uname`.strip.to_sym
    case sys
    when :Darwin
      @@os = Mac.new
    when :Linux
      case `cat /etc/*release`
      when /Fedora/
        @@os = Fedora.new
      when /CentOS/
        @@os = CentOS.new
      when /Deepin/
        @@os = Deepin.new
      when /Red Hat Enterprise Linux Server/
        @@os = RedHatOS.new
      when /Ubuntu/
        @@os = Ubuntu.new
      else
        CLI.error "Unsupport Linux!"
      end
    else
      CLI.error "Unknown OS #{CLI.red sys}!"
    end
    # Delegate commands of OS instance.
    class << self
      @@os.commands.each do |name, block|
        self.send :define_method, name do |*args|
          block.call *args
        end
      end
    end
  end

  def self.mac?
    @@os.type == :mac
  end

  def self.linux?
    [:centos, :fedora, :redhat, :ubuntu].include? @@os.type
  end

  def self.centos?
    @@os.type == :centos
  end

  def self.fedora?
    @@os.type == :fedora
  end

  def self.redhat?
    @@os.type == :redhat
  end

  def self.ld_library_path
    mac? ? 'DYLD_LIBRARY_PATH' : 'LD_LIBRARY_PATH'
  end

  def self.soname
    mac? ? 'dylib' : 'so'
  end
end
