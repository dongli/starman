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
      @@os.type
    end
  end

  def version &block
    if block_given?
      spec.version = block
    else
      @@os.version
    end
  end

  def command name, &block
    if block_given?
      spec.commands[name.to_sym] = block
    else
      @@os.commands[name.to_sym]
    end
  end
end
