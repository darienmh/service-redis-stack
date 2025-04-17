#!/bin/sh
echo "--- Deploying service ---"

echo "Loading environment variables..."
if [ -f ./.env ]; then
    while IFS= read -r line; do
        # Skip empty lines and comments
        case "$line" in
            \#*|"") continue ;;
        esac
        echo "$line"
        export "$line"
    done < ./.env
else
    echo "Error: ./.env file not found"
    exit 1
fi

# Validate required variables
if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: CONTAINER_NAME is not set in .env file"
    exit 1
fi

echo "Environment variables loaded"
echo "Container name: $CONTAINER_NAME"
echo "Working directory: $(pwd)"

# Stop service if it exists
echo "Removing existing stack..."
docker stack rm "$CONTAINER_NAME"
sleep 5

# Deploy the service
echo "Deploying new stack..."
docker stack deploy -c docker-compose-stack.yml "$CONTAINER_NAME"
echo "Waiting for service to start..."
sleep 10

echo "--- Checking if the service is running ---"
i=1
max_attempts=5
while [ $i -le $max_attempts ]; do
    if docker service ps "${CONTAINER_NAME}_redis" 2>/dev/null | grep "Running" > /dev/null; then
        echo "The service is deployed correctly"
        echo "redis://:$REDIS_PASSWORD@localhost:$REDIS_EXTERNAL_PORT/0"
        echo "--- Service deployed successfully ---"
        exit 0
    fi
    echo "Attempt $i: Service not ready yet, waiting..."
    i=$((i + 1))
    sleep 5
done

echo "Error: The service failed to start after multiple attempts"
docker service logs "${CONTAINER_NAME}_redis" 2>/dev/null || echo "No logs available yet"
exit 1

