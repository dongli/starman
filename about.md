---
layout: page
title: About
permalink: /about/
---

Install software dependencies for HPC applications (e.g., numerical climate or weather models) can be a pain in the ass. There are so many libraries to install, which number exceeds your fingers even with your toes. Although the native package manager like RPM in RedHat Linux serves us a mountain of software packages, there are still unsatisfactory aspects:

- Out-to-date software
- Isolated servers without internet connection
- Old GCC compilers

You can install all the packages manually (most admins do this) with the needed compilers, but it will takes you several days or maybe weeks to setup a ready-for-use environment, and you will probaly meet errors which will accelerate your heart beats! Smart people may write BASH scripts to do the jobs, but when they want to deal with different scenarios, they will end up with scripts that are complicated and hard to maintain.

STARMAN is a solution to shield users from the wild software environment. It installs the libraries like YUM does but can switch to different compilers easily. When the target server is disconnected from internet, users can pack all the packages, and upload them to the server, and unpack them to a proper location, then use STARMAN to install them one by one automatically.