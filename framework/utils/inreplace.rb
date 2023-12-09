module Utils
  def inreplace file_paths, before = nil, after = nil, &block
    Array(file_paths).each do |file_path|
      tmp = File.readlines(file_path)
      lines = {}
      tmp.each_with_index do |line, idx|
        if not line.valid_encoding?
          lines[idx+1] = line.encode('UTF-16be', invalid: :replace, replace: '?').encode('UTF-8')
        else
          lines[idx+1] = line
        end
      end
      content = lines.values.join ''
      if block_given?
        block.call content
      elsif before.class == Hash and not after
        before.each do |key, value|
          content.gsub! key, value
        end
      elsif (before.class == String or before.class == Regexp) and after.class == String
        content.gsub! before, after
      elsif before.class == Fixnum and after.class == String
        lines[before] += after + "\n"
        content = lines.values.join ''
      end
      write_file file_path, content
    end
  end
end
