# Service Redis Stack

This project provides a Docker configuration to run Redis Stack, which includes Redis and RedisInsight, with optimized and customizable settings.

## 🚀 Features

- Redis Stack with RedisInsight included
- Customizable configuration through environment variables
- Configured data persistence
- Automatic healthcheck
- Optimized memory and expiration policy settings

## 📋 Prerequisites

- Docker
- Docker Compose

## 🔧 Setup

1. Clone the repository:
```bash
git clone git@github.com:darienmh/service-redis-stack.git
cd service-redis-stack
```

2. Copy the environment variables example file:
```bash
cp example.env .env
```

3. Adjust the variables in the `.env` file according to your needs:
- `REDIS_VERSION`: Redis Stack version (default: latest)
- `CONTAINER_NAME`: Container name
- `REDIS_EXTERNAL_PORT`: External port for Redis (default: 6379)
- `REDIS_O_EXTERNAL_PORT`: External port for RedisInsight (default: 8001)
- `REDIS_PASSWORD`: Authentication password

### Generate random password
```bash
openssl rand -base64 30 | tr -dc 'a-zA-Z0-9' | head -c 30 && echo
```

## 🚀 Usage

To start the service:

```bash
docker-compose up -d
```

To stop the service:

```bash
docker-compose down
```

## 🔍 Access

- Redis: `localhost:6379`
- RedisInsight: `http://localhost:8001`

## ⚙️ Redis Configuration

The `redis-stack.conf` file includes the following settings:
- Maximum memory: 4GB
- Memory policy: allkeys-lru
- AOF persistence enabled

## 🔄 Healthcheck

The service includes an automatic healthcheck that:
- Runs every 30 seconds
- Has a timeout of 20 seconds
- Makes 3 attempts before marking the container as unhealthy

## 📁 Project Structure

```
.
├── docker-compose.yml
├── entrypoint.sh
├── redis-stack.conf
├── .env
├── example.env
└── redis-data/
```

## 🔒 Security

- It is recommended to change the default password in the `.env` file
- Persistent data is stored in the `redis-data/` directory

## 📝 License MIT

## 🤝 Contributing

Contributions are welcome. Please open an issue first to discuss the changes you would like to make.
