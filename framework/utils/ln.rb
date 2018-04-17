module Utils
  def ln src, dst
    Dir.glob src do |src_file|
      FileUtils.ln_sf src_file, dst
    end
  end
end
