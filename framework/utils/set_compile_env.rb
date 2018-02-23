module Utils
  def set_compile_env
    ENV['CC'] = c_compiler
    ENV['CXX'] = cxx_compiler
    ENV['FC'] = fortran_compiler
    ENV['F77'] = fortran_compiler
  end
end
