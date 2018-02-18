Introduction
============

This is the third time I rewrote this package manager, and hope this will be
the final version. This time I try to simplify the design to make STARMAN
robust and focus on HPC usage. I set down the following goals:

- User can use `load` command to change shell environment for specific packages
  like `modules`.
- Support package update which is lacked in previous version.

Prerequisites
=============

STARMAN is implemented by using Ruby programming language which is good at
writing DSL (Domain Specific Language), so the system should have Ruby
installed.

- Ruby >= 2.0
- SQLite

Installation
============

Put STARMAN in any location, and add the following `source` statement in your `.bashrc`:

```
source <STARMAN_directory>/setup/bashrc
```

Usage
=====

You can list the help message of each command by:

```
$ starman <command> -h/--help
```

```
      _______  _______  _______  ______    __   __  _______  __    _
     |       ||       ||   _   ||    _ |  |  |_|  ||   _   ||  |  | |
     |  _____||_     _||  |_|  ||   | ||  |       ||  |_|  ||   |_| |
     | |_____   |   |  |       ||   |_||_ |       ||       ||       |
     |_____  |  |   |  |       ||    __  ||       ||       ||  _    |
      _____| |  |   |  |   _   ||   |  | || ||_|| ||   _   || | |   |
     |_______|  |___|  |__| |__||___|  |_||_|   |_||__| |__||_|  |__|

STARMAN: Another package manager for Linux/Mac programmer.
Copyright (C) 2015-2018 - All Rights Reserved.

    >>> starman install <package_name> ... [options]

    -r, --rc-root PATH               Set runtime configuration root directory.
    -d, --debug                      Print debug information.
    -v, --verbose                    Print more information including build output.
    -c, --compiler-set NAME          Set the active compiler set by its name set in conf file.
    -k, --skip-test                  Skip possible build test (e.g., make test)
    -h, --help                       Print this help message.
```

Install package
---------------

```
$ starman install netcdf
```

Load package
------------

In your `.bashrc` after STARMAN source statement, add the load commands:

```
starman load netcdf@4.6.0
```

Uninstall package
-----------------

```
$ starman uninstall netcdf
```

or

```
$ starman rm netcdf
```
