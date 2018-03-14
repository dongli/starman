class PackageLinker
  extend Utils

  def self.link package
    regex = /#{package.prefix}\/?(.*)/
    Dir.glob("#{package.prefix}/**/*").each do |file_path|
      next if File.directory? file_path
      basename = File.basename file_path
      subdir = File.dirname(file_path).match(regex)[1]
      dir = "#{package.link_root}/#{subdir}"
      # Fix 'libtool: warning: library XXX was moved.' problem.
      inreplace file_path, /^libdir='.*'$/, "libdir='#{dir}'" if basename =~ /.*\.la$/
      FileUtils.mkdir_p dir if not File.directory? dir
      FileUtils.ln_sf file_path, "#{dir}/#{basename}"
    end
  end

  def self.unlink package
    regex = /#{package.prefix}\/?(.*)/
    Dir.glob("#{package.prefix}/**/*").each do |file_path|
      next if File.directory? file_path
      basename = File.basename file_path
      subdir = File.dirname(file_path).match(regex)[1]
      dir = "#{package.link_root}/#{subdir}"
      FileUtils.rm_f "#{dir}/#{basename}"
      # Remove empty directory.
      FileUtils.rmdir dir if Dir.glob("#{dir}/*").size == 0
    end
  end
end
