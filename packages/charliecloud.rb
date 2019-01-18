class Charliecloud < Package
  url 'https://github.com/hpc/charliecloud/archive/v0.9.6.tar.gz'
  sha256 '50e20d5e2a3710cd06e7c999db22495b07ef0fb15ffbc0af3bccac5387f0fddb'
  file_name 'charliecloud-0.9.6.tar.gz'

  label :common

  def install
    run 'make'
    run 'make', 'install', "PREFIX=#{prefix}"
  end
end
