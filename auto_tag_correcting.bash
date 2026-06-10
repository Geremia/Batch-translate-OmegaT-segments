#!/usr/bin/bash

# Automatically fix broken/missing tags
# Make sure the "Issues" window is open and focused before running this script

tags=${1:?number of tags to fix}
delay=${2:?delay in seconds between actions}

WID=$(xdotool search --name "Issues")

# Define a cleanup function to release the keys
cleanup() {
    echo -e "\nScript interrupted! Resetting keyboard modifiers..."
    xdotool keyup alt ctrl shift
    exit 1
}
# "Trap" SIGINT (Ctrl+C) and SIGTERM, and run the cleanup function
trap cleanup SIGINT SIGTERM

xdotool windowactivate --sync $WID
for i in $(seq 1 $tags); do
  sleep $delay
  xdotool key alt+f
done

