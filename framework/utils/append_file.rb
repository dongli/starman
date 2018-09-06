module Utils
  def append_file file_path, content = nil, &block
    dir = File.dirname file_path
    mkdir_p dir if not Dir.exist? dir
    file = File.open file_path, 'a'
    if block_given?
      content ||= ''
      yield content
    end
    file << content
    file.close
  end
end
