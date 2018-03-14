class CompilerSpec
  attr_accessor :vendor, :version, :active_language

  def eval language
    self.version = Version.new self.version.call(language.to_s) if self.version.class == Proc
  end
end
