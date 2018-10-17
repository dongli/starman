module Utils
  def std_cmake_args options = {}
    args = %W[
      -DCMAKE_SYSTEM_PREFIX_PATH=#{Settings.link_root}
      -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG
      -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -Wno-dev
    ]
    args << "-DCMAKE_PREFIX_PATH=#{options[:search_paths].join}" unless options[:search_paths].empty?
    args
  end
end
