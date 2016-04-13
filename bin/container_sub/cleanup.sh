#!/bin/sh

COMMAND_OPTIONS="
-i REMOVE_UNTAGGED_IMAGES 0
"
. "${SUBCOMMAND_DIR}/command_options_process.sh" $*

CONTAINERS=$(docker ps -q -a)

if [ "${CONTAINERS}" != "" ]; then
    echo "Removing Containers..."
    CONTAINERS="docker rm ${CONTAINERS}"
    "${CONTAINERS}"
fi


if [ ${REMOVE_UNTAGGED_IMAGES} ]; then
    IMAGES=$(docker images | grep "^<none>" | awk '{print $3}')
    if [ "${IMAGES}" != "" ]; then
        echo "Removing Images..."
        IMAGES="docker rmi ${IMAGES}"
        "${IMAGES}"
    fi
fi

exit 0
