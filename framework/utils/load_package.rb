module Utils
  def load_package package
    return if package.has_label? :alone and CommandParser.command != :install
    append_path package.bin if Dir.exist? package.bin
    append_ld_library_path package.lib if Dir.exist? package.lib
    append_ld_library_path package.lib64 if Dir.exist? package.lib64
    append_pkg_config_path package.lib + '/pkgconfig' if Dir.exist? package.lib + '/pkgconfig'
    append_pkg_config_path package.lib64 + '/pkgconfig' if Dir.exist? package.lib64 + '/pkgconfig'
    append_manpath package.man if Dir.exist? package.man
    package.export_env
  end
end
