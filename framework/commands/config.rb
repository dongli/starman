class ConfigCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman config [options]
EOS
    @parser.parse!
    Settings.init ignore_errors: true
  end

  def run
    system "vi -c 'set filetype=yaml' #{Settings.conf_file}"
  end
end
