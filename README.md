# Docker Directory Script

This Bash script is designed to iterate through Docker directories under `/docker`, allowing you to interactively decide whether to process each directory. It automates pulling, shutting down, and starting up Docker services using `docker-compose`.

## Features
- **Interactive Directory Selection:**
  - Prompts you to include or exclude each directory.
- **Safety Checks:**
  - Verifies the presence of `docker-compose.yml` in each directory before executing commands.
- **Automated Workflow:**
  - Executes `docker compose pull`, `docker compose down`, and `docker compose up -d` for selected directories.

## Prerequisites
- Bash shell environment.
- Docker and Docker Compose installed.
- Subdirectories in `/docker` containing valid `docker-compose.yml` files.

## Usage
### 1. Save the Script
Save the following script as `update_docker.sh`:

```bash
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
```

### 2. Make It Executable
Run the following command to make the script executable:
```bash
chmod +x update_docker.sh
```

### 3. Run the Script
Execute the script:
```bash
./update_docker.sh
```

### 4. Interactive Prompts
The script will prompt you for each directory in `/docker`:
- Enter `y` to process the directory.
- Enter `n` to skip the directory.

## Example Output
If `/docker` contains three directories (`service1`, `service2`, and `service3`), the script might output:

```plaintext
Do you want to process the directory '/docker/service1'? (y/n): y
Processing directory: /docker/service1
Found docker-compose.yml in /docker/service1
Pulling images...
Stopping services...
Starting services...

Do you want to process the directory '/docker/service2'? (y/n): n
Skipping directory: /docker/service2

Do you want to process the directory '/docker/service3'? (y/n): y
Processing directory: /docker/service3
Found docker-compose.yml in /docker/service3
Pulling images...
Stopping services...
Starting services...

All directories processed.
```

## Notes
- Ensure `/docker` contains the directories you want to process.
- Each directory should have a valid `docker-compose.yml` file.
- Use with caution in production environments, as `docker compose down` stops all running containers in the directory.

## License
This script is open-source and can be modified to suit your needs.
