module Utils
  def system_command? cmd
    `which #{cmd} 2>&1`
    return true if $?.success?
  end
end
