class EditCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman edit <package_name>
EOS
    @parser.parse!
    Settings.init
  end

  def run
    cmd = system_command?('vim') ? 'vim' : 'vi'
    system "#{cmd} -c 'set filetype=ruby' #{ENV['STARMAN_ROOT']}/packages/#{ARGV.last}.rb"
  end
end
