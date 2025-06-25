#!/bin/bash

# Check for required arguments
if [ $# -ne 3 ]; then
  echo "Usage: $0 <VSIX_PATH> <FLOGO_PROJECT_PATH> <CONTEXT_NAME>"
  exit 1
fi

# Assign input arguments to variables
VSIX_PATH="$1"
FLOGO_PROJECT_PATH="$2"
CONTEXT_NAME="$3"

# Step 1: Check if context already exists
echo "Checking if context '$CONTEXT_NAME' exists..."
if ./flogobuild list-context | grep -q "$CONTEXT_NAME"; then
  echo "Context '$CONTEXT_NAME' already exists. Skipping context creation."
else
  echo "Context '$CONTEXT_NAME' not found. Creating context..."
  ./flogobuild create-context -n "$CONTEXT_NAME" -v "$VSIX_PATH"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to create FLOGO MCP context."
    exit 1
  fi
fi

# Step 2: Build FLOGO Executable
echo "Building FLOGO executable for project: $FLOGO_PROJECT_PATH ..."
./flogobuild build-exe -f "$FLOGO_PROJECT_PATH"
if [ $? -ne 0 ]; then
  echo "Error: Failed to build FLOGO executable."
  exit 1
fi

echo "FLOGO build process completed successfully."
