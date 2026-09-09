#!/bin/bash

IMAGE="diagnostic-tool"

echo "Building Docker image..."
docker build -t "$IMAGE" .

if [[ $? -ne 0 ]]; then
    echo "FAIL: Docker image build failed."
    exit 1
fi

echo
echo "Test 1: help"
if docker run --rm "$IMAGE" help >/dev/null 2>&1; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

echo
echo "Test 2: system"
if docker run --rm "$IMAGE" system >/dev/null 2>&1; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

echo
echo "Test 3: disk"
if docker run --rm "$IMAGE" disk >/dev/null 2>&1; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

echo
echo "Test 4: invalid command"
docker run --rm "$IMAGE" invalid-command >/dev/null 2>&1

if [[ $? -eq 2 ]]; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

echo
echo "All tests passed."
exit 0
