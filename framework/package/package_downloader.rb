class PackageDownloader
  extend Utils

  def self.downloaded? package
    path = "#{Settings.cache_root}/#{package.file_name}"
    return package.sha256 == Digest::SHA256.hexdigest(File.read(path)) if File.file? path
  end

  def self.download package
    return if downloaded? package
    CLI.notice "Downloading #{package.url} ..."
    FileUtils.mkdir_p Settings.cache_root if not File.directory? Settings.cache_root
    curl package.url, Settings.cache_root, rename: package.file_name
  end
end
