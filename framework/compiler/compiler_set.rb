class CompilerSet
  def self.init
    command_patterns = {
      gcc: {
        c: /gcc(-\d+)?$/,
        cxx: /g\+\+(-\d+)?$/,
        fortran: /gfortran(-\d+)?$/
      },
      intel: {
        c: /icc$/,
        cxx: /icpc$/,
        fortran: /ifort$/
      }
    }
    [:c, :cxx, :fortran].each do |language|
      case Settings.compilers[language.to_s]
      when command_patterns[:gcc][language]
        self.class_variable_set :"@@#{language}_compiler", Gcc.new(language)
      when command_patterns[:intel][language]
        self.class_variable_set :"@@#{language}_compiler", Intel.new(language)
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
