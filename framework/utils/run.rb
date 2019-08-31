module Utils
  def run cmd, *options
    cmd_line = "#{cmd} #{options.select { |option| option.class == String }.join(' ')}"
    if CommandParser.args[:verbose] or options.include? :verbose
      CLI.blue_arrow cmd_line
      system cmd_line
    else
      CLI.blue_arrow cmd_line, :truncate
      system "#{cmd_line} 1>#{Settings.cache_root}/stdout.#{Process.pid} 2>#{Settings.cache_root}/stderr.#{Process.pid}"
    end
    if not $?.success?
      CLI.error "Failed to run #{cmd_line}!" +
        "#{CommandParser.args[:verbose] || " Check logs:\n#{Settings.cache_root}/stdout.#{Process.pid}\n#{Settings.cache_root}/stderr.#{Process.pid}"}"
    else
      FileUtils.rm_f "#{Settings.cache_root}/stdout.#{Process.pid}"
      FileUtils.rm_f "#{Settings.cache_root}/stderr.#{Process.pid}"
    end
  end

  def success? cmd, *options
    cmd_line = "#{cmd} #{options.select { |option| option.class == String }.join(' ')}"
    system "#{cmd_line} &> /dev/null"
    $?.success?
  end
end
