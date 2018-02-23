module Utils
  def append_path path
    return if ENV['PATH'].include? path
    ENV['PATH'] = "#{path}:#{ENV['PATH']}"
  end

  def append_ld_library_path path
    return if ENV[OS.ld_library_path].include? path
    ENV[OS.ld_library_path] = "#{path}:#{ENV[OS.ld_library_path]}"
  end
end
