class Lua < Package
  url 'https://www.lua.org/ftp/lua-5.4.4.tar.gz'
  sha256 '164c7849653b80ae67bec4b7473b884bf5cc8d2dca05653475ec2ed27b9ebf61'

  label :common
  label :skip_if_exist, include_file: 'lua5.4/lua.h'

  if not CompilerSet.c.clang?
    depends_on :readline
    depends_on :ncurses
  end

  def install
    inreplace 'src/Makefile', {
      /^\s*CC\s*=.*$/ => "CC = #{CompilerSet.c.command}",
    }
    if not OS.mac? and not CompilerSet.c.clang?
      inreplace 'src/Makefile', {
        /^\s*CFLAGS\s*=(.*)$/ => "CFLAGS = \\1 -fPIE -I#{Readline.inc} -I#{Ncurses.inc}",
        /^\s*LDFLAGS\s*=(.*)$/ => "LDFLAGS = \\1 -L#{Readline.lib} -L#{Ncurses.lib}",
        /^\s*LIBS\s*=(.*)$/ => "LIBS = \\1 -lncursesw"
      }
    end
    inreplace 'src/luaconf.h', {
      /#define LUA_ROOT.*/ => "#define LUA_ROOT \"#{prefix}\""
    }
    if OS.linux?
      platform = 'linux'
    elsif OS.mac?
      platform = 'macosx'
    else
      platform = 'generic'
    end
    run 'make', platform, "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man}/man1"
    run 'make', 'install', "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man}/man1"
    mkdir "#{lib}/pkgconfig"
    File.open("#{lib}/pkgconfig/lua.pc", 'w') do |file|
      file << <<-EOT
V= #{Version.new(version).major_minor}
R= #{version}
prefix=#{prefix}
INSTALL_BIN= ${prefix}/bin
INSTALL_INC= ${prefix}/include
INSTALL_LIB= ${prefix}/lib
INSTALL_MAN= ${prefix}/share/man/man1
INSTALL_LMOD= ${prefix}/share/lua/${V}
INSTALL_CMOD= ${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: #{version}
Requires:
Libs: -L${libdir} -llua -lm
Cflags: -I${includedir}
      EOT
    end
  end
end
