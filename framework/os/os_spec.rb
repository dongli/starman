class OsSpec
  attr_accessor :type, :version

  def eval
    self.version = Version.new self.version.call if self.version.class == Proc
  end
end
