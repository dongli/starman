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
    res = `echo 'select * from install where name = \"#{package.name}\";' | #{db_cmd} #{db_path}`.split("\n")
    res.each do |record|
      columns = record.split('|')
      next unless columns[3] =~ /#{Settings.compiler_set}/
      # If old version package has been installed, we should tell user that
      # he/she must use force option to override with newer version.
      if package.version != columns[2] or package.prefix != columns[3]
        if CommandParser.args[:force]
          return false
        else
          package.version = columns[2]
          return :old_version_installed
        end
      else
        return true
      end
    end
  end
end
