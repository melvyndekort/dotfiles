#!/bin/sh

watch grep -e Dirty: -e Writeback: /proc/meminfo

