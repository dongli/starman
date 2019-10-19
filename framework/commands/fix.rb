class FixCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman fix
EOS
    Settings.init
  end

  def run
    fix_history_db_compiler_set
  end

  def fix_history_db_compiler_set
    # Fix history.db to add 'compiler_set' column.
    res = `echo 'select id, name, prefix, compiler_set from install;' | #{History.db_cmd} #{History.db_path}`.split("\n")
    if $?.exitstatus != 0
      res = `echo 'alter table install add compiler_set varchar(30);' | #{History.db_cmd} #{History.db_path}`
      if $?.exitstatus != 0
        p res
        exit 1
      end
    else
      res.map! { |record| record.split('|') }
      res.each do |columns|
        if not columns[3]
          compiler_set = columns[2].delete_prefix(Settings.install_root + '/').split('/').first
          if compiler_set != 'common'
            res = `echo 'update install set compiler_set = "#{compiler_set}" where id = "#{columns[0]}";' | #{History.db_cmd} #{History.db_path}`
            if $?.exitstatus != 0
              p res
              exit 1
            end
          end
        end
      end
    end
  end
end
