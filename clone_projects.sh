#!/bin/sh

while read p; do
  cd google_projects
  nohup git clone $p &
done <google_github_projects.txt
