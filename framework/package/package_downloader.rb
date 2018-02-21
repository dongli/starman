class PackageDownloader
  def self.downloaded? package
    path = cache_path package
    return package.sha256 == Digest::SHA256.hexdigest(File.read(path)) if File.file? path
  end

  def self.cache_path package
    FileUtils.mkdir_p Settings.cache_root if not File.directory? Settings.cache_root
    "#{Settings.cache_root}/#{package.file_name}"
  end

  def self.download package
    return if downloaded? package
    CLI.notice "Downloading #{package.url} ..."
    uri = URI(package.url)
    case uri.scheme
    when 'ftp'
      ftp = Net::FTP.new
      ftp.passive = true
      ftp.connect uri.host, uri.port
      ftp.login
      total_size = ftp.size(uri.path).to_f
      downloaded_size = 0
      ftp.getbinaryfile(uri.path, cache_path(package), 1024) do |chunk|
        downloaded_size += chunk.size
        print "\r#{(downloaded_size / total_size * 100).round(0)}%"
      end
      print "\r"
      ftp.close
    when 'http', 'https'
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        res = http.request_head(uri)
        total_size = res['content-length'].to_f
        downloaded_size = 0
        req = Net::HTTP::Get.new uri
        http.request req do |res|
          open cache_path(package), 'wb' do |file|
            res.read_body do |chunk|
              file.write chunk
              downloaded_size += chunk.bytesize
              print "\r#{(downloaded_size / total_size * 100).round(0)}%"
            end
          end
        end
      end
      print "\r"
    end
  end
end
