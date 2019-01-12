class ListCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman list
EOS
    # Parse package names and load them.
    parse_packages relax: true
    @parser.parse!
    Settings.init
  end

  def run
    PackageLoader.loaded_packages.keys.map(&:to_s).sort.map(&:to_sym).each do |name|
      package = PackageLoader.loaded_packages[name]
      print "#{CLI.blue name}@#{package.version}\n"
    end
  end
end
