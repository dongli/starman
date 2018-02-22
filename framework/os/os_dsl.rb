module OsDSL
  def self.included base
    base.extend self
  end

  def spec
    return self.class_variable_get "@@#{self}_spec" if self.class_variable_defined? "@@#{self}_spec"
    self.class_variable_set "@@#{self}_spec", OsSpec.new
  end

  def type val = nil
    if val != nil
      spec.type = val.to_sym
    else
      self.class_variable_get(:@@os).type
    end
  end

  def version &block
    if block_given?
      spec.version = block
    else
      self.class_variable_get(:@@os).version
    end
  end
end
