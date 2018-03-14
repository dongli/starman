require 'minitest/autorun'
require "#{ENV['STARMAN_ROOT']}/framework"

class TestCompilerSet < Minitest::Test
  def setup
    Settings.settings['defaults'] = {
      'compiler_set' => 'gcc'
    }
    Settings.settings['compiler_sets'] = {
      'gcc' => {
        'c' => '/usr/bin/gcc',
        'cxx' => '/usr/bin/g++',
        'fortran' => '/usr/bin/gfortran'
      }
    }
  end

  def test_compiler_set_initilizer
    CompilerSet.init
    assert_equal :gcc, CompilerSet.c.vendor
    assert_equal :gcc, CompilerSet.cxx.vendor
    assert_equal :gcc, CompilerSet.fortran.vendor
    assert CompilerSet.c.gcc?
  end
end
