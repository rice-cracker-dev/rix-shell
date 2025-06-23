#!/usr/bin/env bash

printf "[general]
mode = waves
framerate = 60
autosens = 1
bars = %s

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000
channels = mono
mono_option = average

[smoothing]
noise_reduction = 40
waves = 1
" "$2" | cava -p /dev/stdin
