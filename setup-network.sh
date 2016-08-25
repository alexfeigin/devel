#!/bin/bash
log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
log "Disable firewalld and NetworkManager enable legacy network"
systemctl disable firewalld;
systemctl stop firewalld;
systemctl disable NetworkManager;
systemctl stop NetworkManager;
systemctl start network;
systemctl enable network;
log finished
