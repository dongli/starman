class UnlinkCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman unlink <package_name> ... [options]
EOS
    parse_packages
    @parser.parse!
  end

  def run
    PackageLoader.loaded_packages.each do |name, package|
      next if not PackageLoader.from_cmd_line? package or package.has_label? :alone
      CLI.notice "Unlink package #{CLI.green package.name} ..."
      PackageLinker.unlink package
    end
  end
end
