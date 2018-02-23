$LOAD_PATH << "#{ENV['STARMAN_ROOT']}/framework"

require 'digest'
require 'forwardable'
require 'fileutils'
require 'net/http'
require 'net/ftp'
require 'optparse'
require 'uri'
require 'yaml'

require 'utils/append_env'
require 'utils/cli'
require 'utils/cd'
require 'utils/work_in'
require 'utils/mkdir'
require 'utils/decompose'
require 'utils/write_file'
require 'utils/inreplace'
require 'utils/run'
require 'utils/std_cmake_args'
require 'utils/set_compile_env'
require 'utils/version'

require 'os/os_spec'
require 'os/os_dsl'
require 'os/os'
require 'os/mac'
require 'os/centos'

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
require 'commands/load'
