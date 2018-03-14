require 'minitest/autorun'
require "#{ENV['STARMAN_ROOT']}/framework"

Settings.init

class TestPackage < Minitest::Test
  def test_that_openssl_should_be_linked_into_a_separate_dir
    PackageLoader.loads :openssl
    openssl = PackageLoader::Openssl.new
    assert_match /openssl\/link$/, openssl.link_root
  end

  def test_that_group_package_should_be_loaded_when_slave_package_is_loaded
    PackageLoader.loads 'netcdf-c'
    assert PackageLoader.loaded_packages.has_key? :netcdf
  end
end
