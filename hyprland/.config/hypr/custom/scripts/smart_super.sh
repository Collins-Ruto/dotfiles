#!/bin/bash
# Save this as ~/.config/hypr/scripts/smart_super.sh and make executable

# Define the maximum time in milliseconds for a "tap"
MAX_TAP_DURATION=200

# Get key press time from file
if [ -f /tmp/hypr_super_press_time ]; then
  PRESS_TIME=$(cat /tmp/hypr_super_press_time)
  RELEASE_TIME=$(date +%s%N)
  
  # Calculate duration in milliseconds
  DURATION=$(( (RELEASE_TIME - PRESS_TIME) / 1000000 ))
  
  # Only trigger rofi if the key was tapped (not held)
  if [ "$DURATION" -lt "$MAX_TAP_DURATION" ]; then
    rofi -show drun
  fi
  
  # Clean up
  rm /tmp/hypr_super_press_time
fi
