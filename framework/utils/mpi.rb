module Utils
  class MPI
    def self.openmpi?
      `#{File.dirname ENV['MPICC']}/mpiexec --version`.match('OpenRTE')
    end
  end
end
