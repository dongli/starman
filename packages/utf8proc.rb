class Utf8proc < Package
  url 'https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.9.0.tar.gz'
  sha256 '18c1626e9fc5a2e192311e36b3010bfc698078f692888940f1fa150547abb0c1'
  file_name 'utf8proc-2.9.0.tar.gz'

  label :common

  def install
    run 'make', 'install', "prefix=#{prefix}"
  end
end
