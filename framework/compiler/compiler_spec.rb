class CompilerSpec
  attr_accessor :vendor, :version, :active_language, :command

  def eval language
    self.version = Version.new self.version.call(language.to_s) if self.version.class == Proc
    self.command = Settings.compilers[language.to_s]
  end
end
