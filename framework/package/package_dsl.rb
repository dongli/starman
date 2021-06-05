module PackageDSL
  def self.included base
    base.extend self
  end

  def spec
    package_class = self.name.split('::').last
    return self.class_variable_get "@@#{package_class}_spec" if self.class_variable_defined? "@@#{package_class}_spec"
    self.class_variable_set "@@#{package_class}_spec", PackageSpec.new 
  end

  [:url, :mirror, :sha256, :version, :file_name].each do |keyword|
    self.send :define_method, keyword do |val = nil|
      if val
        spec.send "#{keyword}=", val
      else
        spec.send keyword
      end
    end
  end

  [:label, :depends_on].each do |keyword|
    self.send :define_method, keyword do |val, options = {}|
      spec.send keyword, val, options
    end
  end

  def conflicts_with *val
    spec.conflicts_with *val
  end

  def grouped_by val
    spec.group = val.to_sym
  end

  def option name, desc, options = {}
    name = name.gsub('-', '_').to_sym
    options[:desc] = desc
    options[:type] = :boolean if not options[:type]
    spec.option name, options
    # Create a helper for querying option.
    case options[:type]
    when :boolean
      define_method(:"#{name}?") do
        @spec.options[name][:value]
      end
      self.class.send :define_method, :"#{name}?" do
        self.class_variable_get("@@#{self.name.split('::').last}_spec").options[name][:value]
      end
      define_method(:"#{name}=") do |val|
        @spec.options[name][:value] = val
      end
    else
      define_method(:"#{name}") do
        @spec.options[name][:value] || @spec.options[name][:default]
      end
      self.class.send :define_method, :"#{name}" do
        self.class_variable_get("@@#{self.name.split('::').last}_spec").options[name][:value] ||
        self.class_variable_get("@@#{self.name.split('::').last}_spec").options[name][:default]
      end
    end
  end

  def resource name, &block
    return spec.resources[name.to_sym] if not block_given?
    res = PackageSpec.new
    res.instance_eval &block
    spec.resource name, res
  end

  def patch options=nil, &block
    if options == :DATA
      data = ''
      start = false
      File.open("#{ENV['STARMAN_ROOT']}/packages/#{Package.package_name self}.rb", 'r').each do |line|
        if line =~ /__END__/
          start = true
          next
        end
        data << line if start
      end
      spec.patch data
    elsif options.class == Hash
      spec.patch options, &block
    else
      spec.patch &block
    end
  end

  def skip_test?
    CommandParser.args[:skip_test]
  end

  def multiple_jobs?
    CommandParser.args.has_key? :make_jobs
  end

  def jobs_number
    CommandParser.args[:make_jobs]
  end

  def link src, dst
    spec.link src, dst
  end
end
