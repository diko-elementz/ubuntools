#!/bin/sh


CONTAINER=$(container info -a -m)


if [ "${CONTAINER}" ]; then
    docker exec -t -i "${CONTAINER}" /bin/bash
fi
