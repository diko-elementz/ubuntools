#!/bin/sh

echo "current: ${CURRENT_DIR}"
DOCKERFILE="${CURRENT_DIR}/Dockerfile"

### check image
if [ ! -f "${DOCKERFILE}" ]; then
    echo "${COMMAND} requires docker file" >&2
    exit 10
fi

