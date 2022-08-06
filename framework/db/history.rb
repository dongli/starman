class History
  extend Utils

  def self.db_path
    "#{Runtime.rc_root}/history.db"
  end

  def self.db_cmd
    'sqlite3'
  end

  def self.init
    if not system_command? 'sqlite3'
      CLI.error 'There is no sqlite3!'
    end
    # Create history database if not exists.
    if not File.file? db_path
      CLI.notice "Initialize history database at #{CLI.blue db_path}."
      FileUtils.mkdir_p File.dirname(db_path)
      old_ld_library_path = ENV[OS.ld_library_path]
      ENV[OS.ld_library_path] = ''
      system "cat #{ENV['STARMAN_ROOT']}/framework/db/tables.sql | #{db_cmd} #{db_path}"
      ENV[OS.ld_library_path] = old_ld_library_path
    end
  end

  def self.save_install package
    old_ld_library_path = ENV[OS.ld_library_path]
    ENV[OS.ld_library_path] = ''
    system "echo 'insert into install (name, version, prefix, compiler_set, options, time) " +
    "values (\"#{package.name}\", \"#{package.version}\", \"#{package.prefix}\", \"#{Settings.compiler_set}\", " +
    "\"#{package.options.to_s.gsub('"', '""')}\", \"#{Time.now}\");' | #{db_cmd} #{db_path}"
    ENV[OS.ld_library_path] = old_ld_library_path
  end

  def self.remove_install package
    old_ld_library_path = ENV[OS.ld_library_path]
    ENV[OS.ld_library_path] = ''
    system "echo 'delete from install where prefix = \"#{package.prefix}\";' | #{db_cmd} #{db_path}"
    ENV[OS.ld_library_path] = old_ld_library_path
    CLI.error "Failed to update history database!" if not $?.success?
  end

  def self.installed_packages
    old_ld_library_path = ENV[OS.ld_library_path]
    ENV[OS.ld_library_path] = ''
    res = `echo 'select name from install where compiler_set = "#{Settings.compiler_set}";' | #{db_cmd} #{db_path}`.split("\n")
    ENV[OS.ld_library_path] = old_ld_library_path
    return [] if res.empty?
    res.map! { |record| record.split('|') }
    package_names = []
    res.each do |columns|
      package_names << columns[0]
    end
    PackageLoader.loads package_names
  end

  def self.installed? package
    old_ld_library_path = ENV[OS.ld_library_path]
    ENV[OS.ld_library_path] = ''
    if package.has_label? :group
      res = `echo 'select * from install where like(\"#{File.dirname(package.prefix)}%\", prefix);' | #{db_cmd} #{db_path}`.split("\n")
    else
      res = `echo 'select * from install where name = \"#{package.name}\";' | #{db_cmd} #{db_path}`.split("\n")
    end
    ENV[OS.ld_library_path] = old_ld_library_path
    return false if res.empty?
    res.map! { |record| record.split('|') }
    res.sort_by! { |columns| columns[2] }
    res.each do |columns|
      next unless package.has_label?(:common) or package.has_label?(:compiler) or columns[3] =~ /#{Settings.compiler_set}/
      # If old version package has been installed, we should tell user that
      # he/she must use force option to override with newer version.
      if package.version != columns[2] or package.prefix != columns[3]
        if CommandParser.args[:force]
          res = :different_version_installed_but_unlink_it
        else
          res = [:different_version_installed, columns[2]]
        end
      else
        # If name and version match, just return.
        return true
      end
    end
    res
  end
end
