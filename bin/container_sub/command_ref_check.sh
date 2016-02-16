#!/bin/sh

NAME=${1}

if [ ! "${NAME}" ]; then
    echo "${COMMAND} requires Named reference."
    exit 12
fi
