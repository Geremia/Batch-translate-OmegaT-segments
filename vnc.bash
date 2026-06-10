#!/bin/bash

export DISPLAY=":${1:?Specify display number ∈ [1,99]}"
DISPLAY_NUM=${DISPLAY#:}
if [ $DISPLAY_NUM -gt 99 ] || [ $DISPLAY_NUM -lt 1 ]; then
    echo "Display number must be ∈ [1,99]"
    exit 1
fi
export RFBPORT=$((5900 + $DISPLAY_NUM))
export HOST_DISPLAY=${HOST_DISPLAY:-:0}

trap 'echo "Shutting down environment…"; kill 0' EXIT

rm -f /tmp/.X11-unix/X$DISPLAY_NUM /tmp/.X$DISPLAY_NUM-lock

echo "Starting Xvfb on display $DISPLAY…"
mkdir -p /tmp/empty_egl
__EGL_VENDOR_LIBRARY_FILENAMES=/tmp/empty_egl Xvfb $DISPLAY -screen 0 2560x1600x24 -dpi 192 &> /dev/null &
sleep 1

echo "Starting x0vncserver to serve on localhost:$RFBPORT…"
x0vncserver -display $DISPLAY -SecurityTypes None -localhost -rfbport $RFBPORT &> /dev/null &
sleep 1

echo "Starting openbox…"
openbox &> /dev/null &
sleep 1

echo "Starting OmegaT…"
OmegaT &> /dev/null &
sleep 1

echo "Starting vncviewer on \$HOST_DISPLAY = $HOST_DISPLAY…"
DISPLAY=$HOST_DISPLAY vncviewer localhost:$RFBPORT &> /dev/null &

echo "Environment is up! Press Ctrl+C to close everything."
wait


# Run the auto_tag_correcting.bash & automate_replace_with_machine_translation.bash scripts in that display, e.g.:
# $ DISPLAY=$DISPLAY_NUM ./automate_replace_with_machine_translation.bash
# $ DISPLAY=$DISPLAY_NUM ./auto_tag_correcting.bash
