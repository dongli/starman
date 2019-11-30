#!/bin/bash

export STARMAN_ROOT=$(cd $(dirname $BASH_SOURCE) && cd .. && pwd)

# Check some commands presence.
for cmd in wget gcc make; do
  if ! (which $cmd > /dev/null); then
    echo "[Error]: No $cmd is installed by system! Please install one by apt-get or yum according to your OS."
    exit 1
  fi
done

# Check Ruby availability.
SQLITE_URL=https://sqlite.org/2019/sqlite-autoconf-3300100.tar.gz
SQLITE_SHA=8383f29d53fa1d4383e4c8eb3e087f2ed940a9e0
SQLITE_PACKAGE=$(basename $SQLITE_URL)
SQLITE_PACKAGE_DIR=$(basename $SQLITE_PACKAGE .tar.gz)

if which shasum 2>&1 1> /dev/null 2>&1; then
  SHASUM=shasum
elif which sha1sum 2>&1 1> /dev/null 2>&1; then
  SHASUM=sha1sum
else
  SHASUM=none
fi

function install_sqlite
{
  if [[ -f "$STARMAN_ROOT/sqlite/bin/sqlite3" ]]; then
    export PATH=$STARMAN_ROOT/sqlite/bin:$PATH
    return
  fi
  if [[ ! -d "$STARMAN_ROOT/sqlite" ]]; then
    mkdir "$STARMAN_ROOT/sqlite"
  fi
  cd $STARMAN_ROOT/sqlite
  if [[ ! -f $SQLITE_PACKAGE ]]; then
    wget $SQLITE_URL -O $SQLITE_PACKAGE
  fi
  if [[ "$SHASUM" == 'none' || "$($SHASUM $SQLITE_PACKAGE | cut -d ' ' -f 1)" != "$SQLITE_SHA" ]]; then
    echo '[Error]: SQLITE is not downloaded successfully!'
    exit 1
  fi
  rm -rf $SQLITE_PACKAGE_DIR
  tar -xzf $SQLITE_PACKAGE
  cd $SQLITE_PACKAGE_DIR
  echo "[Notice]: Building SQLITE, please wait for a moment!"
  export LD_LIBRARY_PATH=
  # In some environment, openssl cannot been compiled with successfully, so disable the openssl ext.
  CC=gcc CFLAGS=-fPIC ./configure --prefix=$STARMAN_ROOT/sqlite 1> $STARMAN_ROOT/sqlite/out 2>&1
  make install 1>> $STARMAN_ROOT/sqlite/out 2>&1
  if [[ $? == 0 ]]; then
    cd $STARMAN_ROOT/sqlite
    rm -rf $SQLITE_PACKAGE_DIR
    export PATH=$STARMAN_ROOT/sqlite/bin:$PATH
  else
    echo "[Error]: Failed to build SQLITE! please see $STARMAN_ROOT/sqlite/out!"
    exit 1
  fi
}

if ! which sqlite3 2>&1 1> /dev/null 2>&1; then
  echo '[Warning]: System does not provide a SQLITE! STARMAN will install one for you!'
  install_sqlite
fi

cd "$OLD_DIR"

# Check .bashrc in HOME.
if [[ "$SHELL" =~ "bash" ]]; then
  if [[ -d "$STARMAN_ROOT/sqlite/bin" ]]; then
    LINE="export PATH=$STARMAN_ROOT/sqlite/bin:\$PATH"
    if ! grep "$LINE" ~/.bashrc 1>/dev/null; then
      echo $LINE >> ~/.bashrc
      echo "[Notice]: Append \"$LINE\" into ~/.bashrc. Reopen or relogin to the terminal please."
    fi
  fi
else
  echo "[Error]: Shell $SHELL is not supported currently!"
  exit 1
fi
