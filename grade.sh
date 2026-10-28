#!/usr/bin/env bash
set -u
PASS=0; FAIL=0
pass(){ echo "PASS: $1"; PASS=$((PASS+1)); }
fail(){ echo "FAIL: $1"; FAIL=$((FAIL+1)); }
echo "=== Assignment 2 - Dockerized Diagnostic CLI ==="
for f in README.md Dockerfile compose.yaml .dockerignore app/diagnostic.sh test.sh; do
  [[ -f "$f" ]] && pass "Required file exists: $f" || fail "Missing required file: $f"
done
for f in app/*.sh test.sh; do
  [[ -f "$f" ]] || continue
  bash -n "$f" >/dev/null 2>&1 && pass "Bash syntax: $f" || fail "Bash syntax error: $f"
done
[[ -x app/diagnostic.sh ]] && pass "diagnostic.sh is executable" || fail "app/diagnostic.sh is not executable"
if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker is required to grade Assignment 2."; exit 2
fi
grep -Eq '^[[:space:]]*FROM[[:space:]]+' Dockerfile && pass "Dockerfile has FROM" || fail "Dockerfile has no FROM"
grep -Eq 'ENTRYPOINT|CMD' Dockerfile && pass "Dockerfile defines ENTRYPOINT or CMD" || fail "Dockerfile has neither ENTRYPOINT nor CMD"
grep -Eq '^\.git/?$' .dockerignore && pass ".dockerignore excludes .git" || fail ".dockerignore should exclude .git"
IMAGE=student-diagnostic-grader
if docker build -t "$IMAGE" . >/tmp/assignment2-build.log 2>&1; then
  pass "Docker image builds successfully"
  for cmd in help system disk; do
    if docker run --rm "$IMAGE" "$cmd" >/tmp/assignment2-test.log 2>&1; then pass "Docker command '$cmd' works"; else fail "Docker command '$cmd' failed"; cat /tmp/assignment2-test.log; fi
  done
  docker run --rm "$IMAGE" invalid-command >/tmp/assignment2-test.log 2>&1; rc=$?
  [[ $rc -ne 0 ]] && pass "Invalid command returns non-zero" || fail "Invalid command should return non-zero"
else
  fail "Docker image failed to build"; cat /tmp/assignment2-build.log
fi
if docker compose config >/tmp/assignment2-compose.log 2>&1; then pass "Docker Compose configuration is valid"; else fail "Docker Compose configuration is invalid"; cat /tmp/assignment2-compose.log; fi
if [[ -x ./test.sh ]]; then
  if ./test.sh >/tmp/assignment2-student.log 2>&1; then pass "Student test.sh passes"; else fail "Student test.sh fails"; cat /tmp/assignment2-student.log; fi
else
  echo "WARN: test.sh is not executable; running with bash"
  if bash ./test.sh >/tmp/assignment2-student.log 2>&1; then pass "Student test.sh passes"; else fail "Student test.sh fails"; cat /tmp/assignment2-student.log; fi
fi
docker image rm "$IMAGE" >/dev/null 2>&1 || true
echo "======================================"; echo "Passed: $PASS"; echo "Failed: $FAIL"
[[ $FAIL -eq 0 ]]
