module Utils
  def cd dir, *options
    if dir == :back
      FileUtils.chdir @@cd_dir_stack.last
      @@cd_dir_stack.pop
    else
      @@cd_dir_stack ||= []
      @@cd_dir_stack << FileUtils.pwd if not options.include? :not_record
      FileUtils.chdir dir
    end
  end
end