class CommandParser
  include Utils

  def initialize
    @parser = OptionParser.new
    @@args = {}
    @parser.banner = <<-EOS
      _______  _______  _______  ______    __   __  _______  __    _ 
     |       ||       ||   _   ||    _ |  |  |_|  ||   _   ||  |  | |
     |  _____||_     _||  |_|  ||   | ||  |       ||  |_|  ||   |_| |
     | |_____   |   |  |       ||   |_||_ |       ||       ||       |
     |_____  |  |   |  |       ||    __  ||       ||       ||  _    |
      _____| |  |   |  |   _   ||   |  | || ||_|| ||   _   || | |   |
     |_______|  |___|  |__| |__||___|  |_||_|   |_||__| |__||_|  |__|

STARMAN: Another package manager for Linux/Mac programmer.
Copyright (C) 2015-2018 - All Rights Reserved.
Sponsored by Longrun Weather Inc..
EOS
    @parser.separator ''
    @parser.on '-rPATH', '--rc-root PATH', 'Set runtime configuration root directory.' do |path|
      @@args[:rc_root] = path
    end
    @parser.on '-d', '--debug', 'Print debug information.' do
      @@args[:debug] = true
    end
    @parser.on '-v', '--verbose', 'Print more information including build output.' do
      @@args[:verbose] = true
    end
    @parser.on_tail '-h', '--help', 'Print this help message.' do
      print @parser.help
      exit
    end
  end

  def parse_packages options = {}
    # We really needs rc_root!
    ARGV.each_with_index do |arg, i|
      if arg == '-r' or arg == '--rc-root'
        @@args[:rc_root] = ARGV[i+1]
        break
      end
    end
    Settings.init silent: true
    History.init
    CompilerSet.init
    # NOTE: Package names should be prior to options.
    finish = false
    package_names = []
    package_names << 'gcc' if CompilerSet.needs_load?
    ARGV.each do |arg|
      finish = true if arg[0] == '-'
      package_names << arg unless finish
    end
    PackageLoader.loads package_names, options
  end

  def self.args
    @@args ||= {}
  end
end
