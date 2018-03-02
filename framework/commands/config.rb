class ConfigCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman config [options]
EOS
    @parser.parse!
  end

  def run
    system "vim -c 'set filetype=yaml' #{Settings.conf_file}"
  end
end
