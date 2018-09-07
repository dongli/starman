#!/bin/bash

# Check Ruby availability.
RUBY_URL=https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.0.tar.gz
RUBY_SHA=d44a3c50a0e742341ed3033d5db79d865151a4f4
RUBY_PACKAGE=$(basename $RUBY_URL)
RUBY_PACKAGE_DIR=$(basename $RUBY_PACKAGE .tar.gz)

if which shasum 2>&1 1> /dev/null 2>&1; then
  SHASUM=shasum
elif which sha1sum 2>&1 1> /dev/null 2>&1; then
  SHASUM=sha1sum
else
  SHASUM=none
fi

function install_ruby
{
  if [[ -f "$STARMAN_ROOT/ruby/bin/ruby" ]]; then
    export PATH=$STARMAN_ROOT/ruby/bin:$PATH
    return
  fi
  if [[ ! -d "$STARMAN_ROOT/ruby" ]]; then
    mkdir "$STARMAN_ROOT/ruby"
  fi
  cd $STARMAN_ROOT/ruby
  if [[ ! -f $RUBY_PACKAGE ]]; then
    wget $RUBY_URL -O $RUBY_PACKAGE
  fi
  if [[ "$SHASUM" == 'none' || "$($SHASUM $RUBY_PACKAGE | cut -d ' ' -f 1)" != "$RUBY_SHA" ]]; then
    echo '[Error]: Ruby is not downloaded successfully!'
    exit 1
  fi
  rm -rf $RUBY_PACKAGE_DIR
  tar -xzf $RUBY_PACKAGE
  cd $RUBY_PACKAGE_DIR
  echo "[Notice]: Building Ruby, please wait for a moment! If anything is wrong, please see $STARMAN_ROOT/ruby/out!"
  if ! which gcc 2>&1 1> /dev/null 2>&1; then
    echo '[Error]: There is no GCC compiler!'
    exit 1
  fi
  export LD_LIBRARY_PATH=
  CC=gcc CFLAGS=-fPIC ./configure --prefix=$STARMAN_ROOT/ruby --disable-install-rdoc 1> $STARMAN_ROOT/ruby/out 2>&1
  make install 1>> $STARMAN_ROOT/ruby/out 2>&1
  cd $STARMAN_ROOT/ruby
  rm -rf $RUBY_PACKAGE_DIR
  export PATH=$STARMAN_ROOT/ruby/bin:$PATH
}

if ! which ruby 2>&1 1> /dev/null 2>&1; then
  echo '[Warning]: System does not provide a Ruby! STARMAN will install one for you!'
  install_ruby
fi

RUBY_VERSION=$(ruby -v | cut -d ' ' -f 2)
if [[ $RUBY_VERSION =~ $(echo '^1\.8') || $RUBY_VERSION =~ $(echo '^1\.9') ]]; then
  echo "[Warning]: Ruby version is too old, STARMAN will install a newer one for you!"
  install_ruby
fi

cd "$OLD_DIR"

# Check .bashrc in HOME.
if [[ "$SHELL" =~ "bash" ]]; then
  if [[ -d "$STARMAN_ROOT/ruby/bin" ]]; then
    LINE="export PATH=$STARMAN_ROOT/ruby/bin:\$PATH"
    if ! grep "$LINE" ~/.bashrc 1>/dev/null; then
      echo $LINE >> ~/.bashrc
      echo "[Notice]: Append \"$LINE\" into ~/.bashrc. Reopen or relogin to the terminal please."
    fi
  fi
else
  echo "[Error]: Shell $SHELL is not supported currently!"
  exit 1
fi
