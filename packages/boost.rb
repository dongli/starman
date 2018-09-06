class Boost < Package
  url 'https://jaist.dl.sourceforge.net/project/boost/boost/1.68.0/boost_1_68_0.tar.bz2'
  sha256 '7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7'
  version '1.68.0'

  depends_on :icu4c

  def install
    append_file 'user-config.jam' do |content|
      if OS.mac?
        content << "using darwin : : #{ENV['CXX']} ;\n"
      elsif OS.linux?
        content << "using gcc : : #{ENV['CXX']} ;\n"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --with-icu=#{Icu4c.link_root}
      --without-libraries=python,mpi
    ]
    run './bootstrap.sh', *args

    run './b2', 'headers'

    args = %W[
      --prefix=#{prefix}
      -d2
      -j#{CommandParser.args[:make_jobs]}
      --user-config=user-config.jam
      -sNO_LZMA=1
      install
      threading=multi
      link=shared
      cxxflags=-std=c++11
    ]
    run './b2', *args
  end
end
