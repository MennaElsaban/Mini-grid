#!/bin/bash

# Get the number of CPU cores
NUM_CORES=$(cat /proc/cpuinfo | grep processor | wc -l)

# Server FIFO
SERVER_FIFO="/tmp/server-$melsaban-inputfifo"

# Create server FIFO if it doesn't exist
[ -p "$SERVER_FIFO" ] || mkfifo "$SERVER_FIFO"

# Array to track worker PIDs
declare -a WORKER_PIDS=()

# Counter for tasks processed
TASKS_PROCESSED=0

# Function to start worker processes
start_workers() {
  echo "Starting up $NUM_CORES processing units"
  for ((i = 1; i <= NUM_CORES; i++)); do
    ./worker.sh $i &   # worker script (worker.sh)
    WORKER_PIDS+=($!)  # Store the worker PIDs in the array
  done
  echo "Ready for processing: place tasks into $SERVER_FIFO"
}

# Error handling for worker script
if [ ! -e ./worker.sh ]; then
  echo "Error: worker.sh script not found in the current directory."
  exit 1
fi

# Handle unexpected termination of worker processes
cleanup() {
  for pid in "${WORKER_PIDS[@]}"; do
    kill "$pid"  # Terminate worker processes
  done
  rm "$SERVER_FIFO"  # Remove server FIFO
  exit 1
}

trap 'cleanup' EXIT

# Call start_workers function to initiate worker processes
start_workers

# Function to assign tasks in round-robin fashion
assign_task() {
  local task="$1"
  local worker_index=$(( (TASKS_PROCESSED % NUM_CORES) ))
  echo "CMD $task" > "/tmp/worker-$melsaban-$worker_index-inputfifo"
  echo "Task assigned: $task to worker ${WORKER_PIDS[$worker_index]}"
  ((TASKS_PROCESSED++))
}

# Function to handle special commands
handle_special_command() {
  local command="$1"
  case "$command" in
    "status")
      # Print the number of workers and tasks processed
      echo "Number of Workers: ${#WORKER_PIDS[@]}"
      echo "Number of Tasks Processed: $TASKS_PROCESSED"
      ;;
    "shutdown")
      # Clean up and exit
      cleanup
      ;;
    *)
      echo "Unknown command: $command"
      ;;
  esac
}

# Main loop to read commands from the server FIFO
while true; do
  read -r command < "$SERVER_FIFO"

  if [[ "$command" == "CMD"* ]]; then
    # Regular task, assign to a worker
    echo "Assigning task"
    assign_task "${command#CMD }"
  else
    # Special command
    handle_special_command "$command"
  fi
done