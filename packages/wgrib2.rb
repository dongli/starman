class Wgrib2 < Package
  url 'https://www.ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v3.1.1'
  sha256 '9236f6afddad76d868c2cfdf5c4227f5bdda5e85ae40c18bafb37218e49bc04a'
  file_name 'wgrib2-3.1.1.tar.gz'
  version '3.1.1'

  label :common

  def install
    run 'make'
    mkdir bin
    cp './wgrib2/wgrib2', bin
  end
end
