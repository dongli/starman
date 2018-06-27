class LinkCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman link <package_name> ... [options]
EOS
    parse_packages
    @parser.parse!
  end

  def run
    PackageLoader.loaded_packages.each do |name, package|
      next if not PackageLoader.from_cmd_line? package or package.has_label? :not_link
      CLI.notice "Link package #{CLI.green package.name} ..."
      PackageLinker.link package
    end
  end
end
