class Mac < OS
  type :mac

  version do
    `sw_vers`.match(/ProductVersion:\s*(.*)$/)[1]
  end

  def arm?
    `uname -m`.chomp == 'arm64'
  end
end
