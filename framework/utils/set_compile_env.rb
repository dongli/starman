module Utils
  def set_compile_env
    ENV['CC'] = c_compiler
    ENV['CXX'] = cxx_compiler
    ENV['FC'] = fortran_compiler
    ENV['F77'] = fortran_compiler
    ['lib', 'lib64'].each do |lib_dir|
      ENV[OS.ld_library_path] = "#{Settings.link_root}/#{lib_dir}:#{ENV[OS.ld_library_path]}" if File.directory? "#{Settings.link_root}/#{lib_dir}"
    end
  end
end
