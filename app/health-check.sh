#!/bin/bash

#Run diagnostic.sh system. If it works, say OK. If it fails, say FAILED
if ./diagnostic.sh system >/dev/null 2>&1; then
    echo "Diagnostic Tool Health Check"
    echo "Status: OK"
    exit 0
else
    echo "Diagnostic Tool Health Check"
    echo "Status: FAILED"
    exit 1
fi
