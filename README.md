# Dockerized Diagnostic CLI

A Bash-based diagnostic command-line application packaged and run using Docker.

## Project Structure

```text
assignment-2/
├── README.md
├── app/
│   ├── diagnostic.sh
│   └── health-check.sh
├── Dockerfile
├── compose.yaml
├── .dockerignore
├── test.sh
└── grade.sh
```

## Requirements

- Linux environment
- Bash
- Docker
- Docker Compose

## CLI Commands

The application supports the following commands:

```bash
diagnostic system
diagnostic network <host>
diagnostic disk
diagnostic help
```

### System

Displays useful Linux system information.

```bash
docker run --rm diagnostic-tool system
```

### Network

Checks the supplied hostname or IP address.

```bash
docker run --rm diagnostic-tool network google.com
```

### Disk

Displays disk information.

```bash
docker run --rm diagnostic-tool disk
```

### Help

Displays available commands and usage information.

```bash
docker run --rm diagnostic-tool help
```

## Exit Codes

```text
0 - Success
1 - Operational or runtime failure
2 - Invalid command or input
```

## Docker Build

Build the Docker image with:

```bash
docker build -t diagnostic-tool .
```

## Docker Usage

Run the system diagnostic:

```bash
docker run --rm diagnostic-tool system
```

Run the disk diagnostic:

```bash
docker run --rm diagnostic-tool disk
```

Run the network diagnostic:

```bash
docker run --rm diagnostic-tool network google.com
```

Display help:

```bash
docker run --rm diagnostic-tool help
```

## Docker Compose

Build the application using Docker Compose:

```bash
docker compose build
```

Run the application:

```bash
docker compose run --rm diagnostic system
```

Other commands can be run in the same way:

```bash
docker compose run --rm diagnostic disk
docker compose run --rm diagnostic help
docker compose run --rm diagnostic network google.com
```

## Testing

Run Bash syntax checks:

```bash
bash -n app/diagnostic.sh
bash -n app/health-check.sh
bash -n test.sh
```

Run the automated test suite:

```bash
./test.sh
```

The test suite covers:

- Help command
- System command
- Disk command
- Invalid command handling

## Docker Practices

The Docker image uses a lightweight Linux base image and installs only the packages required by the diagnostic application.

The `.dockerignore` file excludes unnecessary files such as Git metadata, logs, and temporary files from the Docker build context.

## Assumptions

- The application is intended to run in a Linux-based Docker environment.
- Docker and Docker Compose are installed and available.
- Network diagnostic results depend on the container's network connectivity and the target host.
