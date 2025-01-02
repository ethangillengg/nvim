#!/usr/bin/env bash
PROCESS_NAME="dotnet-csharpier"
TIMEOUT_SECONDS=$((3600 * 4)) # 4 hours in seconds
SERVER_PORT=42061

# Function to check if the server is running
is_server_running() {
	# Check if the server is running
	pgrep -f "timeout.*$PROCESS_NAME" &>/dev/null
	return $?
}

# Function to start the server in the background with a 4-hour timeout
start_server() {
	echo "Server not running. Starting the 'dotnet-csharpier' server with a timeout of 4 hours..." >&2
	# Start the server under a timeout and save its PID
	timeout $TIMEOUT_SECONDS dotnet-csharpier --server --server-port $SERVER_PORT >&2 2>/dev/null &

	# Give it a sec to startup
	sleep 0.5
	SERVER_PID=$!
	echo "Started 'dotnet-csharpier' with PID $SERVER_PID." >&2
}

# Check if a file name argument is provided
if [ -z "$1" ]; then
	echo "Usage: $0 <file_name>"
	exit 1
fi

FILE_NAME="$1"

# Check if the file exists
if [ ! -f "$FILE_NAME" ]; then
	echo "Error: File '$FILE_NAME' not found!"
	exit 1
fi

# Ensure the server is running before proceeding
if ! is_server_running; then
	start_server
	# Double-check that the server started successfully
	if ! is_server_running; then
		echo "Error: Failed to start the 'dotnet-csharpier' server."
		exit 1
	fi
fi

# Check if the port was retrieved successfully
if [ -z "$SERVER_PORT" ]; then
	echo "Error: Could not determine the listening port for 'dotnet-csharpier'."
	exit 1
fi

# Read the contents of the file
FILE_CONTENTS=$(<"$FILE_NAME")

# Construct the JSON payload
JSON_PAYLOAD=$(
	cat <<EOF
{
  "fileName": "$FILE_NAME",
  "fileContents": $(echo "$FILE_CONTENTS" | jq -Rsa .)
}
EOF
)

# Send the POST request with xh (and handle the server response)
SERVER_RESPONSE=$(echo "$JSON_PAYLOAD" | xh POST http://localhost:$SERVER_PORT/format Content-Type:application/json)

# Output the response from the server (or fallback message)
if [ -n "$SERVER_RESPONSE" ]; then
	echo "$SERVER_RESPONSE" | jq ".formattedFile" -r
else
	echo "No response from server or server connection failed." >&2
	exit 1
fi
