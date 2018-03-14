module CompilerDSL
  def self.included base
    base.extend self
  end

  def spec
    return self.class_variable_get "@@#{self}_spec" if self.class_variable_defined? "@@#{self}_spec"
    self.class_variable_set "@@#{self}_spec", CompilerSpec.new
  end

  def vendor val
    if val != nil
      spec.vendor = val.to_sym
    end
  end

  def version &block
    if block_given?
      spec.version = block
    end
  end
end
