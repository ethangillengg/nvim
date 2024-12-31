#!/bin/bash

# Function to check if the server is running
is_server_running() {
	# Check if the server is responding on port 9999
	nc -z localhost 9999 &>/dev/null
	return $?
}

# Function to start the server in the background
start_server() {
	echo "Server not running. Starting the 'dotnet-csharpier' server on port 9999..." >&2
	nohup dotnet-csharpier --server --server-port 9999 &>/dev/null &
	# Wait a bit to allow the server to initialize
	sleep 2
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
SERVER_RESPONSE=$(echo "$JSON_PAYLOAD" | xh POST http://localhost:9999/format Content-Type:application/json)

# Output the response from the server (or fallback message)
if [ -n "$SERVER_RESPONSE" ]; then
	echo "$SERVER_RESPONSE" | jq ".formattedFile" -r
else
	echo "No response from server or server connection failed." >&2
	exit 1
fi
