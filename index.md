---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

Want to know what STARMAN is? Look [here](/starman/about/).

# Quick start

For those impatient like me, following the breadcrumbs.

Get STARMAN:
```
$ git clone https://github.com/dongli/starman
```

Source STARMAN's bashrc (you should add the line in `~/.bashrc`):
```
$ source <starman>/setup/bashrc
```

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

Install the packages you want (of couse, they must be supported by STARMAN):
```
$ starman install netcdf
```
