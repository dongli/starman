class Readline < Package
  url 'https://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz'
  sha256 '3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35'
  version '8.2'

  label :common
  label :alone
  label :skip_if_exist, include_file: 'readline/readline.h'

  def install
    run './configure', "--prefix=#{prefix}"
    inreplace 'readline.pc', /^(Requires.private: .*)$/, "# \\1" if OS.mac?
    run 'make', 'install'
  end
end
