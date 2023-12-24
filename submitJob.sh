#!/bin/bash

# Server FIFO
SERVER_FIFO="/tmp/server-$USER-inputfifo"

# Function to send a command to the server
send_command() {
  local command="$1"
  echo "$command" > "$SERVER_FIFO"
}

# Main script logic
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <command>"
  exit 1
fi

case "$1" in
  "-s")
    # Send status command to the server
    send_command "status"
    ;;
  "-x")
    # Send shutdown command to the server
    send_command "shutdown"
    ;;
  *)
    # Send the command to the server
    send_command "CMD $1"
    ;;
esac
