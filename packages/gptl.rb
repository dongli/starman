class Gptl < Package
  url 'https://github.com/jmrosinski/GPTL/releases/download/v8.0.3/gptl-8.0.3.tar.gz'
  sha256 '334979c6fe78d4ed1b491ec57fb61df7a910c58fd39a3658d03ad89f077a4db6'

  depends_on :mpi

  def install
    run './configure', "--prefix=#{prefix}"
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
