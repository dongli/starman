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
    system "vi -c 'set filetype=ruby' #{ENV['STARMAN_ROOT']}/packages/#{ARGV.last}.rb"
  end
end
