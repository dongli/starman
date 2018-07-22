#!/bin/bash

cd /opt

git clone https://github.com/dongli/starman && \
. starman/setup/bashrc && \
starman setup --install-root /opt/software

bash
