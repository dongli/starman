class PackageDownloader
  extend Utils

  def self.downloaded? package
    path = "#{Settings.cache_root}/#{package.file_name}"
    package.sha256 == Digest::SHA256.hexdigest(File.read(path)) if File.file? path
  end

  def self.download package
    if not downloaded? package
      if CommandParser.args[:http_cache]
        url = "#{CommandParser.args[:http_cache]}/#{package.file_name}"
      else
        url = package.url
      end
      if not url.nil?
        CLI.notice "Downloading #{url} ..."
        FileUtils.mkdir_p Settings.cache_root if not File.directory? Settings.cache_root
        curl url, Settings.cache_root, rename: package.file_name
      end
    end
    # Download patches if exist.
    package.patches.each_with_index do |patch, index|
      case patch
      when PackageSpec
        next if downloaded? patch
        if CommandParser.args[:http_cache]
          url = "#{CommandParser.args[:http_cache]}/#{patch.file_name}"
        else
          url = patch.url
        end
        CLI.notice "Downloading #{url} ..."
        curl url, Settings.cache_root, rename: patch.file_name
      end
    end
  end
end
