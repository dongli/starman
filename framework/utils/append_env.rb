module Utils
  @@appended_env = {}

  def append_path path
    append_env 'PATH', path
  end

  def append_ld_library_path path
    append_env OS.ld_library_path, path
  end

  def append_pkg_config_path path
    append_env 'PKG_CONFIG_PATH', path
  end

  def append_manpath path
    append_env 'MANPATH', path
  end

  def append_env key, val
    @@appended_env[key] = ENV[key] if not @@appended_env.has_key? key
    @@appended_env[key] = "#{val}:#{@@appended_env[key].gsub(val, '') if @@appended_env[key]}".gsub('::', ':')
  end

  def appended_env
    @@appended_env rescue {}
  end
end
