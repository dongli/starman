class Mct < Package
  url 'https://github.com/MCSclimate/MCT/archive/refs/tags/MCT_2.11.0.zip'
  sha256 'baa1554ca3ccd0a2378b5b09bbd401ef458f967f0deb450049aea65c02db58da'
  version '2.11.0'

  depends_on :mpi

  def install
    args = %W[
      --prefix=#{prefix}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
