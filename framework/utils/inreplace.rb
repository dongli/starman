module Utils
  def inreplace file_paths, before = nil, after = nil, &block
    Array(file_paths).each do |file_path|
      content = File.read(file_path)
      if not content.valid_encoding?
        content = content.encode('UTF-16be', invalid: :replace, replace: '?').encode('UTF-8')
      end
      if block_given?
        block.call content
      elsif before.class == Hash and not after
        before.each do |key, value|
          content.gsub! key, value
        end
      elsif (before.class == String or before.class == Regexp) and after.class == String
        content.gsub! before, after
      end
      write_file file_path, content
    end
  end
end
