#!/bin/bash
/usr/sbin/ntpdate pool.ntp.org >/dev/null 2>&1 && /sbin/hwclock -w &> /dev/null 2>&1
