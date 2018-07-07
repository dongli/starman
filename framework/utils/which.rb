module Utils
  def which cmd
    begin
      `which #{cmd}`.chomp
    rescue
      CLI.error "System command #{CLI.red 'which'} does not exist! Install it with system package manager, and come back!"
    end
  end
end
