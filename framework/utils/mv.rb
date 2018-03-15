module Utils
  def mv src, dst
    FileUtils.mv src, dst.to_s
  end
end
