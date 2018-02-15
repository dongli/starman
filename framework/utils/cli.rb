class CLI
  @@color_map = {
    :red    => 31,
    :green  => 32,
    :yellow => 33,
    :blue   => 34,
    :purple => 35,
    :cyan   => 36,
    :gray   => 37,
    :white  => 39,
  }

  def self.reset
    escape 0
  end

  def self.width
    `tput cols`.strip.to_i
  end

  def self.truncate str
    str.to_s[0, width - 4]
  end

  def self.bold str
    "#{escape(1)}#{str}#{escape(0)}"
  end

  def self.color n
    escape "0;#{n}"
  end

  def self.underline n
    escape "4;#{n}"
  end

  def self.escape n
    "\033[#{n}m" if $stdout.tty?
  end

  @@color_map.each do |color_name, color_code|
    self.class_eval(<<-EOT)
      def self.#{color_name} str = nil
        if str
          "\#{#{color_name}}\#{str}\#{reset}"
        else
          color #{color_code}
        end
      end
    EOT
  end

  def self.blue_arrow message, options = []
    options = [options] if not options.class == Array
    print "#{blue '==>'} "
    if options.include? :truncate
      print "#{truncate message}\n"
    else
      print "#{message}\n"
    end
  end

  def self.print_call_stack
    Kernel.caller.each do |stack_line|
      print "#{red '==>'} #{stack_line}\n"
    end
  end

  def self.notice message
    print "[#{green 'Notice'}]: #{message}\n"
  end

  def self.warning message
    print "[#{yellow 'Warning'}]: #{message}\n"
    print_call_stack if CommandParser.args[:debug]
  end

  def self.error message, options = {}
    if options[:raise_exception]
      raise message
    else
      print "[#{red 'Error'}]: #{message}\n"
      print_call_stack if CommandLine.option(:debug) rescue exit
      exit
    end
  end

  def self.repeat x, times, color, suffix = nil
    for i in 1..times
      if color
        print "#{eval "#{color} x"}"
      else
        print x
      end
    end
    print suffix
  end

  def self.caveat message
    times = [80, width].min
    repeat '#', times/2-4, 'red', "#{red ' CAVEAT '}"
    repeat '#', times-(times/2-4)-8, 'red', "\n"
    message.each_line do |line|
      print line
    end
    repeat '#', times, 'red', "\n"
  end

  def self.pause options = {}
    print options[:message]
    if options.has_key? :seconds
      sleep options[:seconds]
    else
      STDIN.gets
    end
    p
  end
end
