class Vim < Package
  url 'https://github.com/vim/vim/archive/v8.1.0150.tar.gz'
  sha256 'd27812bc4fd0a901e0f3c082ef798cfad10f251adcfc6dec2ca8fcea34b2da17'
  version '8.1.0150'
  file_name 'vim-8.0.0150.tar.gz'

  label :common

  depends_on :lua

  resource :neocomplete do
    url 'https://github.com/Shougo/neocomplete.vim/archive/4be617947f3fcf2d725fab20b0e12f8b46c9e2f3.zip'
    sha256 '41ec5f593981d7455f482ea9adb68dbd31d3a93ef09f4a5be2135b9ad3398cc4'
    file_name 'neocomplete.4be617.zip'
  end

  resource :neosnippet_snippets do
    url 'https://github.com/Shougo/neosnippet-snippets/archive/e5946e9ec4c68965dbabfaaf2584b1c057738afd.zip'
    sha256 '9a8c4ba5228dbcd19ba73d1d179b730fd8fbe24751651eb08431720d5b90625d'
    file_name 'neosnippet_snippets.e5946e.zip'
  end

  resource :neosnippet do
    url 'https://github.com/Shougo/neosnippet.vim/archive/f7755084699db69ce9ff51c87baf8e639b7e543a.zip'
    sha256 'dfd39a8bfa40b18e8d90a084c77621db4dbd267e8fdf792ae27c1ac8934393e0'
    file_name 'neosnippet.f77550.zip'
  end

  resource :nerdtree do
    url 'https://github.com/scrooloose/nerdtree/archive/d6032c876c6d6932ab7f07e262a16c9a85a31d5b.zip'
    sha256 'b2c56084bd9636a9d720fefcc099fea7c6854f8f01b5402acc1c875e9eabe37f'
    file_name 'nerdtree.d6032c.zip'
  end

  resource :vim_ncl do
    url 'https://github.com/dongli/vim-ncl/archive/f4019ebe70df9f1bd2b9a491ea244a7d565f558a.zip'
    sha256 '042cf88d46ca99e436e43aa6778229cacd5ba86567127ae8e27d5baeccb6d441'
    file_name 'vim_ncl.f4019e.zip'
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-multibyte
      --enable-gui=no
      --enable-cscope
      --enable-luainterp=yes
      --with-lua-prefix='#{Lua.prefix}'
      --without-x
      --with-tlib=ncurses
      --with-features=huge
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install', "prefix=#{prefix}", 'STRIP=true'
    ln "#{bin}/vim", "#{bin}/vi"
    # Install handy plugins.
    mkdir "#{share}/vim/vim81/pack/dist/start" do
      install_resource :neocomplete, '.'
      install_resource :neosnippet_snippets, '.'
      install_resource :neosnippet, '.'
      install_resource :nerdtree, '.'
      install_resource :vim_ncl, '.'
    end
  end
end
