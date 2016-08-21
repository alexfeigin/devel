#!/bin/bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y google-chrome-stable_current_x86_64.rpm
rm -f google-chrome-stable_current_x86_64.rpm
