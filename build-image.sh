#!/bin/sh
echo "--- Building image ---"

# Check required files
for file in .env redis-stack.conf entrypoint.sh; do
    if [ ! -f "$file" ]; then
        echo "Error: Required file $file not found"
        exit 1
    fi
done

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
if [ -z "$IMAGE_NAME" ]; then
    echo "Error: IMAGE_NAME is not set in .env file"
    exit 1
fi

# docker buildx create --name multiarch-builder --use
# docker buildx inspect --bootstrap 

echo "Environment variables loaded"
echo "Image name: $IMAGE_NAME"
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg REDIS_VERSION=$REDIS_VERSION \
  -t $IMAGE_NAME:$REDIS_VERSION \
  -t $IMAGE_NAME:latest \
  --push .