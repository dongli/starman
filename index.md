---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

Want to know what STARMAN is? Look [here](/starman/about/).

# Quick start

For those impatient like me, following the breadcrumbs. If you have any doubt, you can open an issue [here](https://github.com/dongli/starman/issues).

## Step 1

Get STARMAN:
```
$ git clone https://github.com/dongli/starman
```

## Step 2

Source STARMAN's bashrc (you should add the line in `~/.bashrc`):
```
$ source <starman>/setup/bashrc
```

## Step 3

Setup STARMAN:
```
$ starman setup \
  --install-root <where to install packages, e.g. /opt/software> \
  --rc-root <for root, set a location where others can read>
```
There are some other options, but they are optional.

Revise configuration:
```
$ starman config
```
You will see a YAML file probaly like this:
```yaml
---
install_root: /opt/software
cache_root: /tmp/starman
defaults:
  compiler_set: gcc_4.8.5
compiler_sets:
  gcc_4.8.5:
    c: /usr/bin/gcc
    cxx: /usr/bin/g++
    fortran: /usr/bin/gfortran
```

## Step 4

Install the packages you want (of couse, they must be supported by STARMAN):
```
$ starman install netcdf
```
You can choose different compiler set if you have added one in command line:
```
$ starman install netcdf -c ifort_17.5.239
```
## Step 5

The packages will be installed to `install_root` as set in configuration file, you could load packages as:
```
$ starman load netcdf [-c ...]
```
You can also specify which compiler set to use by setting `-c` option (e.g. `-c gcc_8.2.0`). After loading, your environment will be changed, where you can inquire package root by `$<PACKAGE_NAME>_ROOT` (e.g. `$NETCDF_ROOT`), and your `PATH`, `LD_LIBRARY_PATH` are set.

It may be tedious to load each installed package, you can load all by:
```
$ starman load --all [-c ...]
```
Instead of getting a root environment variable for each package, you will get a single `STARMAN_INSTALL_ROOT`, so you can use it in your compile command line, Makefile or whatever.
