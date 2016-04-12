#!/bin/sh

COMMAND_OPTIONS="
-i REMOVE_UNTAGGED_IMAGES 0
"
. "${CMD_PARAM_PROCESS}" $*


ACTIVE_CONTAINERS=$(docker ps -q)
if [ "${ACTIVE_CONTAINERS}" != "" ]; then
    echo "Stopping Containers..."
    docker stop ${ACTIVE_CONTAINERS}
fi

CONTAINERS=$(docker ps -q -a)
if [ "${CONTAINERS}" != "" ]; then
    echo "Removing Containers..."
    docker stop ${CONTAINERS}
    docker rm ${CONTAINERS}
fi

if [ "${REMOVE_UNTAGGED_IMAGES_HAS_VALUE}" ]; then
    IMAGES=$(docker images | grep "^<none>" | awk '{print $3}')
    if [ "${IMAGES}" != "" ]; then
        echo "Removing Images..."
        docker rmi ${IMAGES}
    fi
fi

exit 0
