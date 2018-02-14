module PackageDSL
  def self.included base
    base.extend self
  end

  def spec
    return self.class_variable_get "@@#{self}_spec"  if self.class_variable_defined? "@@#{self}_spec"
    self.class_variable_set "@@#{self}_spec", PackageSpec.new 
  end

  [:url, :mirror, :sha256, :version, :file_name].each do |keyword|
    self.define_method(keyword) do |val|
      spec.send "#{keyword}=", val
    end
  end

  [:label, :depends_on, :option].each do |keyword|
    self.define_method(keyword) do |val, options = {}|
      spec.send keyword, val, options
    end
  end
end
