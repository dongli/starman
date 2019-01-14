module Utils
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
    @@appended_env ||= {}
    @@appended_env[key] = "#{val}:#{ENV[key].gsub(/:?#{val}:?/, '') if ENV[key]}"
  end

  def appended_env
    @@appended_env rescue {}
  end
end
