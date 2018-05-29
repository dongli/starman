class History
  def self.db_path
    "#{Runtime.rc_root}/history.db"
  end

  def self.db_cmd
    'sqlite3'
  end

  def self.init
    # Create history database if not exists.
    if not File.file? db_path
      CLI.notice "Initialize history database at #{CLI.blue db_path}."
      FileUtils.mkdir_p File.dirname(db_path)
      system "cat #{ENV['STARMAN_ROOT']}/framework/db/tables.sql | #{db_cmd} #{db_path}"
    end
  end

  def self.save_install package
    system "echo 'insert into install (name, version, prefix, options, time) " +
    "values (\"#{package.name}\", \"#{package.version}\", \"#{package.prefix}\", " +
    "\"#{package.options.to_s.gsub('"', '""')}\", \"#{Time.now}\");' | #{db_cmd} #{db_path}"
  end

  def self.remove_install package
    system "echo 'delete from install where prefix = \"#{package.prefix}\";' | #{db_cmd} #{db_path}"
    CLI.error "Failed to update history database!" if not $?.success?
  end

  def self.installed? package
    res = `echo 'select * from install where name = \"#{package.name}\" and prefix = \"#{package.prefix}\";' | #{db_cmd} #{db_path}`.split('|')
    return true if not res.empty? and package.name == res[1].to_sym and package.version == res[2] and package.prefix == res[3]
  end
end
