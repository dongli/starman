class Readline < Package
  url 'https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz'
  sha256 '750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334'

  label :common
  label :alone
  label :skip_if_exist, include_file: 'readline/readline.h'

  %w[
    001 9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376
    002 8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58
    003 9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780
    004 f925683429f20973c552bff6702c74c58c2a38ff6e5cf305a8e847119c5a6b64
    005 ca159c83706541c6bbe39129a33d63bbd76ac594303f67e4d35678711c51b753
  ].each_slice(2) do |p, checksum|
    patch do
      url "https://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-7.0-patches/readline70-#{p}"
      sha256 checksum
    end
  end

  def install
    run './configure', "--prefix=#{prefix}"
    run 'make', 'install'
  end
end
