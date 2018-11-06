#!/usr/bin/env bash

MEMLOCK_LIMIT=unlimited

echo "# Removing mem-limitations per-process MEMLOCK_LIMIT: '$MEMLOCK_LIMIT'"

echo "*    soft memlock ${MEMLOCK_LIMIT}" >> /etc/security/limits.conf
echo "*    hard memlock ${MEMLOCK_LIMIT}" >> /etc/security/limits.conf
echo "root soft memlock ${MEMLOCK_LIMIT}" >> /etc/security/limits.conf
echo "root hard memlock ${MEMLOCK_LIMIT}" >> /etc/security/limits.conf
