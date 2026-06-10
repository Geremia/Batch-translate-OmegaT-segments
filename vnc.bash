#!/bin/bash

# Clean previous instance
pkill -f Xvfb

# Start Xvfb natively mimicking a High-DPI screen (Double DPI)
mkdir -p /tmp/empty_egl
__EGL_VENDOR_LIBRARY_FILENAMES=/tmp/empty_egl Xvfb :99 -screen 0 2560x1600x24 -dpi 192 &> /dev/null &
sleep 1

# Fire up the VNC translator
x0vncserver -display :99 -SecurityTypes None -localhost &> /dev/null &
sleep 1

# Start Openbox
if ! pgrep -x "openbox" > /dev/null; then
    DISPLAY=:99 openbox &
    sleep 1 # Give it a second to initialize
fi

# launch inside display :99
DISPLAY=:99 OmegaT &> /dev/null &

# Open the viewer normally
vncviewer localhost:5900 &> /dev/null &


# Run the auto_tag_correcting.bash & automate_replace_with_machine_translation.bash scripts in that display, e.g.:
# $ DISPLAY=:99 ./automate_replace_with_machine_translation.bash
# $ DISPLAY=:99 ./auto_tag_correcting.bash
