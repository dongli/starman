class OS
  def self.init
    @@type = `uname`.strip.to_sym
  end

  def self.ld_library_path
    @@type == :Darwin ? 'DYLD_LIBRARY_PATH' : 'LD_LIBRARY_PATH'
  end
end