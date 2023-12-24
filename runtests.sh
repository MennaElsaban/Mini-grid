#!/bin/bash

# Check if the number of arguments is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <number-of-tests>"
    exit 1
fi

# Number of tests
num_tests=$1

# Function to run a test
run_test() {
    local test_number=$1
    local test_description=$2
    local test_command=$3

    echo "Test $test_number: $test_description"
    eval "$test_command"
}

# Loop through the specified number of tests
for ((i = 1; i <= num_tests; i++)); do
    case $i in
        1)
            run_test $i "Basic Functionality" "./submitJob.sh echo 'Task 1'"
            ;;
        2)
            run_test $i "Concurrency" "./submitJob.sh echo 'Task 1' & ./submitJob.sh echo 'Task 2' &"
            ;;
        3)
            run_test $i "Round-Robin Assignment" "./submitJob.sh echo 'Task 1' && ./submitJob.sh echo 'Task 2'"
            ;;
        4)
            run_test $i "Shutdown Command" "./submitJob.sh -x"
            ;;
        5)
            run_test $i "Status Command" "./submitJob.sh -s"
            ;;
        6)
            run_test $i "Error Handling" "./submitJob.sh invalid_command"
            ;;
        7)
            run_test $i "Task Rejection" "# Ensure all workers are busy, then submit a job"
            ;;
        8)
            run_test $i "Communication Protocol" "# Test the order of task assignments and completions"
            ;;
        *)
            echo "Unknown test number: $i"
            ;;
    esac
done