#!/bin/sh

while read p; do
  cd projects
  nohup git clone $p &
done <~/projects.txt
