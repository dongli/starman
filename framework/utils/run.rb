module Utils
  def run cmd, *options
    cmd_line = "#{cmd} #{options.select { |option| option.class == String }.join(' ')}"
    CLI.blue_arrow cmd_line, :truncate
    system cmd_line
    CLI.error "Failed to run #{cmd_line}!" if not $?.success?
  end
end