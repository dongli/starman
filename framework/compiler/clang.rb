class Clang < Compiler
  vendor :clang

  version do |language|
    `#{Settings.compilers[language]} -v 2>&1`.match(/version\s*(\d+\.\d+\.\d+)/)[1]
  end
end
