class SetupCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman setup [options]
EOS
    # Define options.
    @parser.on '--rc-root DIR', 'Set runtime configure root directory.' do |rc_root|
      @@args[:rc_root] = rc_root
    end
    @parser.on '--install-root DIR', 'Set install root directory.' do |install_root|
      @@args[:install_root] = install_root
    end
    @parser.on '--cache-root DIR', 'Set cache root directory.' do |cache_root|
      @@args[:cache_root] = cache_root
    end
    @parser.on '-cVALUE', '--compiler-set VALUE', 'Set compiler set tag or name.' do |compiler_set|
      @@args[:compiler_set] = compiler_set
    end
    @@args[:cc] = 'gcc'
    @parser.on '--cc VALUE', 'Set C compiler command.' do |cc|
      @@args[:cc] = cc
    end
    @@args[:cxx] = 'g++'
    @parser.on '--cxx VALUE', 'Set C++ compiler command.' do |cxx|
      @@args[:cxx] = cxx
    end
    @@args[:fc] = 'gfortran'
    @parser.on '--fc VALUE', 'Set Fortran compiler command.' do |fc|
      @@args[:fc] = fc
    end
    @parser.on '-f', '--force', 'Setup anyway' do
      @@args[:force] = true
    end
    @parser.parse!
    @@args[:rc_root] = "#{ENV['HOME']}/.starman" unless @@args[:rc_root]
    @@args[:cache_root] = "/tmp/starman" unless @@args[:cache_root]
    CLI.error "Option #{CLI.red '--install-root'} is needed!" unless @@args[:install_root]
  end

  def run
    runtime_file = "#{ENV['STARMAN_ROOT']}/.runtime"
    if File.exist? runtime_file and not @@args[:force]
      CLI.error 'STARMAN has been set already!'
    end
    mkdir @@args[:rc_root]
    mkdir @@args[:cache_root]
    Runtime.write @@args
    Settings.write @@args
  end
end
