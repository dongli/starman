module Utils
  def mkdir name, &block
    FileUtils.mkdir_p name
    return unless block_given?
    work_in name do
      yield
    end
  end
end
