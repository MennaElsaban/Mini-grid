# Mini-Grid System

This mini-grid system is a set of cooperating programs for submitting and running independent tasks using bash scripting language and named pipes (FIFOs). The system consists of three main components:

- **Server Script (`msgServer.sh`):**
  - Manages task scheduling and assignment to worker scripts.
  - Reads instructions from its input FIFO.
  - Dynamically starts worker processes based on the number of available CPU cores.
  - Handles special commands such as "status" and "shutdown."

- **Worker Script (`worker.sh`):**
  - Executes tasks assigned by the server.
  - Reports completion status to the server.
  - Saves the output of the task in a log file.

- **Submitter Script (`submitJob.sh`):**
  - Submits tasks to the server.
  - Handles special commands such as displaying the system status and requesting a shutdown.


## Running the System
1. **Start the Server**
```bash
chmod +x msgServer.sh worker.sh submitJob.sh timedCountdown.sh
```
This will start the server and dynamically initiate worker processes based on the available CPU cores.

2. **Submit Tasks:**
Use the submitJob.sh script to submit tasks to the server.
```bash
./submitJob.sh "ls -l"
```

3. Check System Status:
```bash
./submitJob.sh -s
```
This will display the current system status, including the number of workers and tasks processed.

4. **Shutdown the System:**
```bash
./submitJob.sh -x
```
This will send a shutdown command to the server, allowing the system to clean up and exit gracefully.

## Testing
To run the tests, execute the jobs provided in `runtests.sh` script.
OR
Use the provided `timedCountdown.sh` script as a sample task for testing. 

For example:

```bash
./submitJob.sh "./timedCountdown.sh 5"
```
This command will submit a task to the server, which will assign it to a worker. You can observe the countdown messages in the worker's log file.
