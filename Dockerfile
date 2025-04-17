ARG REDIS_VERSION=latest
FROM redis/redis-stack:${REDIS_VERSION}

# copy files
COPY ./entrypoint.sh /entrypoint.sh
COPY ./redis-stack.conf /redis-stack.conf

# make script executable
RUN chmod +x /entrypoint.sh

# default command
CMD ["sh", "/entrypoint.sh"] 