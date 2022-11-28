class CompilerSet
  def self.init
    command_patterns = {
      gcc: {
        c: /\bgcc(-\d+)?$/,
        cxx: /\bg\+\+(-\d+)?$/,
        fortran: /\bgfortran(-\d+)?$/
      },
      clang: {
        c: /\bclang$/,
        cxx: /\bclang\+\+$/
      },
      pgi: {
        c: /\bnvcc$/,
        cxx: /\bnvc\+\+$/,
        fortran: /\bnvfortran$/
      },
      intel: {
        c: /(icc|icx)$/,
        cxx: /(icpc|icpx)$/,
        fortran: /(ifort|ifx)$/
      }
    }
    [:c, :cxx, :fortran].each do |language|
      next unless Settings.compilers[language.to_s]
      case Settings.compilers[language.to_s]
      when command_patterns[:gcc][language]
        self.class_variable_set :"@@#{language}_compiler", GccCompiler.new(language)
      when command_patterns[:clang][language]
        self.class_variable_set :"@@#{language}_compiler", ClangCompiler.new(language)
      when command_patterns[:pgi][language]
        self.class_variable_set :"@@#{language}_compiler", PgiCompiler.new(language)
      when command_patterns[:intel][language]
        self.class_variable_set :"@@#{language}_compiler", IntelCompiler.new(language)
      end
    end
  end

  def self.c
    @@c_compiler
  end

  def self.cxx
    @@cxx_compiler
  end

  def self.fortran
    @@fortran_compiler
  end
end
