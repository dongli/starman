module Utils
  def ssh cmd, options = {}
    user = options[:user] || ENV['USER']
    res = `ssh #{user}@#{options[:host]} #{cmd}`
    return { status: $?, output: res }
  end
end
