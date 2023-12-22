#!/bin/bash

# Worker ID passed as an argument
WORKER_ID="$1"

# Worker FIFO
WORKER_FIFO="/tmp/worker-$melsaban-$WORKER_ID-inputfifo"

# Worker log file
LOG_FILE="/tmp/worker-$melsaban-$WORKER_ID.log"

# Create worker FIFO if it doesn't exist
[ -p "$WORKER_FIFO" ] || mkfifo "$WORKER_FIFO"

# Function to run a task and report completion
run_task() {
  local task="$1"
  echo "Running task: $task"
  # Run the task and save output to log file
  $task > "$LOG_FILE" 2>&1
  # Report completion to the server
  echo "done" > "$SERVER_FIFO"
}

# Main loop to read commands from the worker FIFO
while true; do
  read -r command < "$WORKER_FIFO"

  if [[ "$command" == "shutdown" ]]; then
    # Clean up and exit
    rm "$WORKER_FIFO"
    exit 0
  elif [[ "$command" == "CMD"* ]]; then
    # Regular task, run it
    run_task "${command#CMD }"
  else
    echo "Unknown command: $command"
  fi
done