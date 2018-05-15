#!/usr/bin/env bash

NOFILE_LIMIT=100000

echo "# Increase number of open files limit using NOFILE_LIMIT: '$NOFILE_LIMIT'"

echo "*    soft nofile ${NOFILE_LIMIT}" >> /etc/security/limits.conf
echo "*    hard nofile ${NOFILE_LIMIT}" >> /etc/security/limits.conf
echo "root soft nofile ${NOFILE_LIMIT}" >> /etc/security/limits.conf
echo "root hard nofile ${NOFILE_LIMIT}" >> /etc/security/limits.conf

echo "session required pam_limits.so" >> /etc/pam.d/common-session

echo "session required pam_limits.so" >> /etc/pam.d/common-session-noninteractive
