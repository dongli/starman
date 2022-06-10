class Charliecloud < Package
  url 'https://github.com/hpc/charliecloud/releases/download/v0.27/charliecloud-0.27.tar.gz'
  sha256 '1142938ce73ec8a5dfe3a19a241b1f1ffbb63b582ac63d459aebec842c3f4b72'

  label :common

  def install
    run './configure', "--prefix=#{prefix}"
    run 'make'
    run 'make', 'install'
  end
end
