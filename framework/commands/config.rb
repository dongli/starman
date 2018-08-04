class ConfigCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman config [options]
EOS
    @parser.on '-c', '--compiler-set NAME', 'Set the default compiler set by its name set in conf file.' do |compiler_set|
      @@args[:compiler_set] = compiler_set
    end
    @parser.on '--cc NAME', 'Add new C compiler.' do |cc|
      @@args[:cc] = cc
    end
    @parser.on '--cxx NAME', 'Add new C++ compiler.' do |cxx|
      @@args[:cxx] = cxx
    end
    @parser.on '--fc NAME', 'Add new Fortran compiler.' do |fc|
      @@args[:fc] = fc
    end
    @parser.on '--mpicc NAME', 'Add new MPI C compiler wrapper.' do |mpicc|
      @@args[:mpicc] = mpicc
    end
    @parser.on '--mpicxx NAME', 'Add new MPI C++ compiler wrapper.' do |mpicxx|
      @@args[:mpicxx] = mpicxx
    end
    @parser.on '--mpifc NAME', 'Add new MPI Fortran compiler wrapper.' do |mpifc|
      @@args[:mpifc] = mpifc
    end
    @parser.parse!
    Settings.init only_load: true
  end

  def run
    cmd = system_command?('vim') ? 'vim' : 'vi'
    direct_edit = false
    if @@args[:compiler_set] and @@args[:cc] and @@args[:cxx] and @@args[:fc]
      Settings.settings['compiler_sets'][@@args[:compiler_set]] = {}
      Settings.settings['compiler_sets'][@@args[:compiler_set]]['c'] = @@args[:cc]
      Settings.settings['compiler_sets'][@@args[:compiler_set]]['cxx'] = @@args[:cxx]
      Settings.settings['compiler_sets'][@@args[:compiler_set]]['fortran'] = @@args[:fc]
      Settings.settings['compiler_sets'][@@args[:compiler_set]]['mpi_c'] = @@args[:mpicc] if @@args[:mpicc]
      Settings.settings['compiler_sets'][@@args[:compiler_set]]['mpi_cxx'] = @@args[:mpicxx] if @@args[:mpicxx]
      Settings.settings['compiler_sets'][@@args[:compiler_set]]['mpi_fortran'] = @@args[:mpifc] if @@args[:mpifc]
      Settings.write force: true, just_write: true
      direct_edit = true
    elsif @@args[:compiler_set]
      inreplace Settings.conf_file, /compiler_set:.*$/, "compiler_set: #{@@args[:compiler_set]}"
      direct_edit = true
    end
    system "#{cmd} -c 'set filetype=yaml' #{Settings.conf_file}" unless direct_edit
  end
end
