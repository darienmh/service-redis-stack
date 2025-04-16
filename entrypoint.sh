#!/usr/bin/dumb-init /bin/sh

if [ -f /app/.env ]; then
    while IFS= read -r line; do
        if [[ ! "$line" =~ ^#.*$ ]] && [ ! -z "$line" ]; then
            echo "$line"
            export "$line"
        fi
    done < /app/.env
else
  echo "Error: /app/.env file not found"
  exit 1
fi

### docker entrypoint script, for starting redis stack
BASEDIR=/opt/redis-stack
cd ${BASEDIR}

CMD=${BASEDIR}/bin/redis-server
if [ -f /redis-stack.conf ]; then
    CONFFILE=/redis-stack.conf
fi

if [ -z "${REDIS_DATA_DIR}" ]; then
    REDIS_DATA_DIR=/data
fi

# when running in redis-stack (as opposed to redis-stack-server)
if [ -f ${BASEDIR}/nodejs/bin/node ]; then
    ${BASEDIR}/nodejs/bin/node -r ${BASEDIR}/share/redisinsight/api/node_modules/dotenv/config ${BASEDIR}/share/redisinsight/api/dist/src/main.js dotenv_config_path=${BASEDIR}/share/redisinsight/.env &
fi

if [ -z "${REDISEARCH_ARGS}" ]; then
REDISEARCH_ARGS="MAXSEARCHRESULTS 10000 MAXAGGREGATERESULTS 10000"
fi

${CMD} ${CONFFILE} \
--dir "${REDIS_DATA_DIR}" \
--requirepass "${REDIS_PASSWORD}" \
--protected-mode no \
--daemonize no \
--loadmodule /opt/redis-stack/lib/rediscompat.so \
--loadmodule /opt/redis-stack/lib/redisearch.so ${REDISEARCH_ARGS} \
--loadmodule /opt/redis-stack/lib/redistimeseries.so ${REDISTIMESERIES_ARGS} \
--loadmodule /opt/redis-stack/lib/rejson.so ${REDISJSON_ARGS} \
--loadmodule /opt/redis-stack/lib/redisbloom.so ${REDISBLOOM_ARGS} \
--loadmodule /opt/redis-stack/lib/redisgears.so v8-plugin-path /opt/redis-stack/lib/libredisgears_v8_plugin.so ${REDISGEARS_ARGS} \
${REDIS_ARGS} &

child=$!
wait $child
