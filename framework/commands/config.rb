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
    @parser.parse!
    Settings.init ignore_errors: true
  end

  def run
    cmd = system_command?('vim') ? 'vim' : 'vi'
    direct_edit = false
    if @@args[:compiler_set]
      inreplace Settings.conf_file, /compiler_set:.*$/, "compiler_set: #{@@args[:compiler_set]}"
      direct_edit = true
    end
    system "#{cmd} -c 'set filetype=yaml' #{Settings.conf_file}" unless direct_edit
  end
end
