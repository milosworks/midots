#!/bin/bash
# This script listens for sleep/wake events

case "$1" in
pre)
    openrgb --profile "Blackout"
    ;;
post)
    openrgb --profile "Gray"
    ;;
esac
