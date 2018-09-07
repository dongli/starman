class GccCompiler < Compiler
  vendor :gcc

  version do |language|
    `#{Settings.compilers[language]} -v 2>&1`.match(/^gcc\s+.+\s+(\d+\.\d+\.\d+)/)[1]
  end
end
