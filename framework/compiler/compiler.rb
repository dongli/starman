class Compiler
  include CompilerDSL

  extend Forwardable
  def_delegators :@spec, :vendor, :version

  def initialize language
    @spec = self.class.class_variable_get "@@#{self.class}_spec"
    @spec.eval language
  end

  def gcc?
    @spec.vendor == :gcc
  end

  def intel?
    @spec.vendor == :intel
  end

  def pgi?
    @spec.vendor == :pgi
  end
end
