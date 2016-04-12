#/bin/sh

if [ "${DOCKER_FILE_EXISTS}" != "true" ]; then
    echo "! Dockerfile do no exist in this directory." >&2
    exit 21;
fi

COMMAND_OPTIONS="
-i UNBUILD 0
-s STOP_ONLY 0
"
. "${CMD_PARAM_PROCESS}" $*

######################
# close running
# containers
######################
CONTAINERS=$(docker ps -q -f name=${REF_NAME})
if [ "${CONTAINERS}" ]; then
    if ! docker stop ${CONTAINERS} > /dev/null; then
        echo "! Unable to stop containers: ${CONTAINERS}" >&1
        exit 22
    fi
fi

if [ ! "${STOP_ONLY_HAS_VALUE}" ]; then
    CONTAINERS=$(docker ps -a -q -f name=${REF_NAME})
    if [ "${CONTAINERS}" ]; then
        if ! docker rm ${CONTAINERS} > /dev/null; then
            echo "! Unable to remove containers: ${CONTAINERS}" >&1
            exit 23
        fi
    fi
fi

######################
# unbuild
######################
if [ "${UNBUILD_HAS_VALUE}" ]; then
    container unbuild || exit $?
fi



exit 0
