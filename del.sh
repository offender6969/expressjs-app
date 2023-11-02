GNU nano 6.2                                                                                           del.sh                                                                                                    
#!/bin/bash

# Define the name of the container
CONTAINER_NAME="express-js"

# Check if the container exists
if [[ $(docker ps -q -f name="$CONTAINER_NAME") ]]; then
  echo "Container $CONTAINER_NAME exists. Stopping and removing..."
  # Stop the container
  docker stop "$CONTAINER_NAME"
  # Remove the container
  docker rm "$CONTAINER_NAME"
else
  echo "Container $CONTAINER_NAME does not exist."
fi






