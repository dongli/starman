#!/usr/bin/env ruby

require 'byebug'
require 'forwardable'
require '../utils/version'
require './os_spec'
require './os_dsl'
require './os'
require './mac'

OS.init
p OS.type
p OS.version
