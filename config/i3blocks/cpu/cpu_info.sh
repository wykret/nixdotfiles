#!/bin/sh

TEMP=$(sensors | grep -E 'Package id 0:|Tdie' | grep -o '+[0-9]*\.[0-9]*°C' | head -n1)
CPU_USAGE=$(LC_ALL=C mpstat 1 1 | awk 'END {printf "%.1f%%", 100 - $NF}')

printf " CPU:%s @ %s\n" "$CPU_USAGE" "$TEMP"
