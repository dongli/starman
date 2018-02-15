$LOAD_PATH << "#{ENV['STARMAN_ROOT']}/framework"

require 'forwardable'
require 'fileutils'
require 'net/http'
require 'net/ftp'
require 'uri'
require 'yaml'

require 'utils/cli'
require 'utils/cd'
require 'utils/work_in'
require 'utils/decompose'
require 'utils/write_file'
require 'utils/inreplace'
require 'settings'

require 'db/history'

require 'package/package_spec'
require 'package/package_dsl'
require 'package/package'
require 'package/package_loader'
require 'package/package_downloader'

require 'commands/command_parser'
require 'commands/install'
require 'commands/uninstall'
