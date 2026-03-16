#!/usr/bin/bash

# Automatically translation untranslated OmegaT segments
# Usage: ./automate_replace_with_machine_translation.bash max_segments delay_in_seconds
# Make sure "Options" → "Machine Translation" → "Automatically Fetch Translations" is checked ☑; this speeds up translation.

max_segments=${1:?max segments to translate}
delay=${2:?delay in seconds between segments}

WID=$(xdotool search --name "OmegaT [0-9]")

xdotool windowactivate --sync $WID
for i in $(seq 1 $max_segments); do
  xdotool key ctrl+m
  sleep $delay
  xdotool key ctrl+u
done

