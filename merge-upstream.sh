#!/bin/bash
# 从上游（fork来源仓库）拉取最近更新，拉取到本地upstream分支
git fetch upstream

# 将upstream分支合并到master分支
git add .
git commit -m "merge with upstream 2022年06月28日19:49:34"
git push -u origin master
