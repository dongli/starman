class PackageSpecialLabels
  def self.check label
    case label
    when :mpi
      ENV['MPICC'] != nil and ENV['MPICXX'] != nil and ENV['MPIFC'] != nil
    end
  end
end
