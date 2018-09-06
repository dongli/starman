class Icu4c < Package
  url 'https://ssl.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz'
  sha256 '3dd9868d666350dda66a6e305eecde9d479fb70b30d5b55d78a1deffb97d5aa3'
  version '62.1'

  label :common

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd 'source' do
      run './configure', *args
      run 'make'
      run 'make', 'install'
    end
  end
end
