class PgiCompiler < Compiler
  vendor :pgi

  version do |language|
    `#{Settings.compilers[language]} -V 2>&1`.match(/^pgcc\s+(\d+\.\d+)/)[1]
  end
end
