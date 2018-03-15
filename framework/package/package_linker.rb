class PackageLinker
  extend Utils

  def self.link package
    regex = /#{package.prefix}\/?(.*)/
    if package.links
      # When package maintainer specifies links explicitly, we only link them.
      package.links.each do |src, dst|
        Pathname.new(package.prefix).ascend do |v|
          if File.basename(v) == 'Packages'
            dst = "#{File.dirname v}/#{dst}"
            break
          end
        end
        mkdir dst unless Dir.exist? dst
        Dir.glob(src).each do |file_path|
          next if File.directory? file_path
          basename = File.basename file_path
          FileUtils.ln_sf file_path, "#{dst}/#{basename}"
        end
      end
    else
      Dir.glob("#{package.prefix}/**/*").each do |file_path|
        next if File.directory? file_path
        basename = File.basename file_path
        subdir = File.dirname(file_path).match(regex)[1]
        dir = "#{package.link_root}/#{subdir}"
        # Fix 'libtool: warning: library XXX was moved.' problem.
        inreplace file_path, /^libdir='.*'$/, "libdir='#{dir}'" if basename =~ /.*\.la$/
        mkdir dir unless Dir.exist? dir
        FileUtils.ln_sf file_path, "#{dir}/#{basename}"
      end
    end
  end

  def self.unlink package
    regex = /#{package.prefix}\/?(.*)/
    if package.links
      package.links.each do |src, dst|
        Pathname.new(package.prefix).ascend do |v|
          if File.basename(v) == 'Packages'
            dst = "#{File.dirname v}/#{dst}"
            break
          end
        end
        Dir.glob(src).each do |file_path|
          next if File.directory? file_path
          basename = File.basename file_path
          FileUtils.rm_f "#{dst}/#{basename}"
        end
        # Remove empty directory.
        FileUtils.rmdir dst if Dir.glob("#{dst}/*").size == 0
      end
    else
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
end
