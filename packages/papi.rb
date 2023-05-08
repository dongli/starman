class Papi < Package
  url 'http://icl.utk.edu/projects/papi/downloads/papi-7.0.1.tar.gz'
  sha256 'c105da5d8fea7b113b0741a943d467a06c98db959ce71bdd9a50b9f03eecc43e'

  def install
    work_in 'src' do
      run './configure', "--prefix=#{prefix}"
      run 'make'
      run 'make', 'install'
    end
  end
end
