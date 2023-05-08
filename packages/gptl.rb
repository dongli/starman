class Gptl < Package
  url 'https://github.com/jmrosinski/GPTL/releases/download/v8.1.1/gptl-8.1.1.tar.gz'
  sha256 'b8ee26f7aeedd2a31d565789634e7c380023fe6b65bbf59030884f4dcbce94a5'

  depends_on :mpi
  depends_on :papi unless OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
    ]
    args << '--enable-papi' unless OS.mac?
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
