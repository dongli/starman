module Utils
  def decompress path, options = {}
    args = []
    case path
    when /\.tar.Z$/i
      args << "--strip-components #{options[:strip_leading_dirs]}" if options[:strip_leading_dirs]
      system "tar xzf #{path} #{args.join(' ')}"
    when /\.(tar(\..*)?|tgz|tbz2)$/i
      args << "--strip-components #{options[:strip_leading_dirs]}" if options[:strip_leading_dirs]
      system "tar xf #{path} #{args.join(' ')}"
    when /\.(gz)$/i
      system "gzip -d #{path}"
    when /\.(bz2)$/i
      system "bzip2 -d #{path}"
    when /\.(zip)$/i
      CLI.error 'No unzip is installed by system! Please install one by apt-get or yum according to your OS.' if not system_command? 'unzip'
      system "unzip -o #{path} 1> /dev/null"
      if options[:strip_leading_dirs]
        system 'mv ./*/* .'
      end
    else
      CLI.error "Unknown compression type of #{CLI.red path}!" if options[:exit]
    end
  end
end
