module Utils
  def work_in dir
    CLI.error 'No work block is given!' if not block_given?
    CLI.error "Directory #{CLI.red dir} does not exist!" if not Dir.exist? dir
    cd dir
    yield
    cd :back
  end
end