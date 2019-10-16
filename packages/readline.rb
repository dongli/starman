class Readline < Package
  url 'https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz'
  sha256 'e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461'
  version '8.0.1'

  label :common
  label :alone
  label :skip_if_exist, include_file: 'readline/readline.h'

  def install
    run './configure', "--prefix=#{prefix}"
    inreplace 'readline.pc', /^(Requires.private: .*)$/, "# \\1" if OS.mac?
    run 'make', 'install'
  end
end
