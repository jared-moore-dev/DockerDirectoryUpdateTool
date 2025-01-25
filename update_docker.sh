#!/bin/bash

# Define the base Docker directory
DOCKER_DIR="/docker"

# Iterate through each subdirectory in the Docker directory
for dir in "$DOCKER_DIR"/*; do
  # Check if it's a directory
  if [ -d "$dir" ]; then
    # Prompt the user to include or exclude the directory
    read -p "Do you want to process the directory '$dir'? (y/n): " choice
    
    case "$choice" in
      y|Y )
        echo "Processing directory: $dir"
        
        # Navigate into the directory
        cd "$dir" || { echo "Failed to enter directory: $dir"; continue; }
        
        # Check if docker-compose.yml exists
        if [ -f "docker-compose.yml" ]; then
          echo "Found docker-compose.yml in $dir"
          
          # Run the Docker commands
          docker compose pull && docker compose down && docker compose up -d
        else
          echo "No docker-compose.yml found in $dir, skipping..."
        fi
        ;;
      n|N )
        echo "Skipping directory: $dir"
        ;;
      * )
        echo "Invalid input. Skipping directory: $dir"
        ;;
    esac
  else
    echo "$dir is not a directory, skipping..."
  fi
done

echo "All directories processed."
