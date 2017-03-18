#!/bin/sh

while read p; do
  nohup git clone $p &
done <~/projects.txt
