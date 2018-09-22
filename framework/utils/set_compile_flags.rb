module Utils
  def set_compile_flags package, level = 0
    if level == 0
      ENV['CPPFLAGS'] = ''
      ENV['FCFLAGS'] = ''
      ENV['LDFLAGS'] = ''
    end
    if package
      package.dependencies.each_key do |depend_name|
        depend_package = PackageLoader.loaded_packages[depend_name]
        next if depend_package.skipped?
        flag = " -Wl,-rpath,#{depend_package.link_lib}"
        ENV['LDFLAGS'] += flag if depend_package.link_lib and not ENV['LDFLAGS'].include? flag
        set_compile_flags depend_package, level + 1
      end
    end
  end
end
