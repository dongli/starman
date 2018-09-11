module Utils
  def which cmd
    begin
      `which #{cmd} 2> /dev/null`.chomp
    rescue
      ENV['PATH'].split(':').each do |dir|
        path = "#{dir}/#{cmd}"
        return path if Dir.exist? dir and File.exist? path
      end
    end
  end
end
