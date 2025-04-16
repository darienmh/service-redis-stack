#!/bin/sh
echo "--- Deploying service ---"
echo "Loading environment variables..."
if [ -f ./.env ]; then
    while IFS= read -r line; do
        if [[ ! "$line" =~ ^#.*$ ]] && [ ! -z "$line" ]; then
            #echo "$line"
            export "$line"
        fi
    done < ./.env
else
  echo "Error: ./.env file not found"
  exit 1
fi
echo "Environment variables loaded"
# Stop service if it exists
docker stack rm $CONTAINER_NAME
sleep 5

# Deploy the service
docker stack deploy -c docker-compose-stack.yml $CONTAINER_NAME
echo "Waiting for service to start..."
sleep 10

echo "--- Checking if the service is running ---"
for i in {1..5}; do
    if docker service ps "${CONTAINER_NAME}_redis" | grep "Running" >> /dev/null; then
        echo "The service is deployed correctly"
        echo "redis://:$REDIS_PASSWORD@localhost:$REDIS_EXTERNAL_PORT/0"
        echo "--- Service deployed successfully ---"
        exit 0
    fi
    echo "Attempt $i: Service not ready yet, waiting..."
    sleep 5
done

echo "Error: The service failed to start after multiple attempts"
docker service logs "${CONTAINER_NAME}_redis"
exit 1