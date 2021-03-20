class IntelCompiler < Compiler
  vendor :intel

  version do |language|
    `#{Settings.compilers[language]} -v 2>&1`.match(/^icc\s*(\(ICC\)|version)*\s*(\d+\.\d+(\.\d+)?)/)[2] rescue nil
  end
end
