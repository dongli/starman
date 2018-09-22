module Utils
  def add_env key, val
    @@added_env ||= {}
    @@added_env[key] = val
  end

  def added_env
    @@added_env || {}
  end
end
