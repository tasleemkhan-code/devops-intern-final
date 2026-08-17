#!/bin/bash
# sysinfo.sh - prints basic system info
# Usage: ./sysinfo.sh

echo "===== SYSTEM INFO ====="

echo -n "Current User : "
whoami

echo -n "Current Date : "
date

echo "Disk Usage   :"
df -h

echo "========================"
