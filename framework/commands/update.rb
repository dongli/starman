class UpdateCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman unpdate
EOS
    @parser.parse!
  end

  def run
    work_in ENV['STARMAN_ROOT'] do
      if Dir.exist? '.git'
        system 'git', 'pull'
      else
        CLI.error "Sorry, you haven't installed STARMAN using #{CLI.red 'git'}!"
      end
    end
  end
end