#!/bin/bash

echo "here"
# Check if a duration is provided
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <duration_seconds>"
  exit 1
fi

# Function to perform the countdown
perform_countdown() {
  local duration="$1"
  while [ "$duration" -gt 0 ]; do
    echo "$duration seconds remaining..."
    sleep 1
    ((duration--))
  done
  echo "Countdown complete!"
}

# Main script logic
duration="$1"
perform_countdown "$duration"
