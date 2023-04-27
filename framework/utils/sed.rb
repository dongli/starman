module Utils
  def sed file_path, sed_cmd
    if OS.linux?
      run "sed -i #{sed_cmd} #{file_path}"
    elsif OS.mac?
      run "sed -i '' #{sed_cmd} #{file_path}"
    end
  end
end
