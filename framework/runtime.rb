class Runtime
  extend Utils

  @@runtime = {}

  def self.runtime_file
    ENV['STARMAN_ROOT'] + '/.runtime'
  end

  def self.rc_root
    @@runtime['rc_root']
  end

  def self.init
    if File.exist? runtime_file
      @@runtime = YAML.load(open(runtime_file).read)
    end
  end

  def self.write options
    @@runtime['rc_root'] = options[:rc_root]
    write_file runtime_file, <<-EOS
---
rc_root: #{@@runtime[:rc_root]}
EOS
  end
end
