#!/bin/sh


######################
# load defaults
######################
. "${SUBCOMMAND_DIR}/docker_defaults.sh"

######################
# options
######################
COMMAND_OPTIONS="

-p PORTS 1
-e ENVS 1
-i INTERACTIVE 0
-h HOST_NAME 1

"
. "${SUBCOMMAND_DIR}/command_options_process.sh" $*


######################
# stop container
######################
container stop || exit $?


######################
# find/create image
######################
IMAGES=$(docker images -q ${REF_NAME})
if [ ! "$IMAGES" ]; then
    container build || exit $?
fi


######################
# create run command
######################
DOCKER_CMD="docker run --name ${REF_NAME}"


######################
# defaults
######################
# mount docker source files
DOCKER_CMD="${DOCKER_CMD} -v ${CURRENT_DIR}:${SERVICE_SOURCE}:ro"
DOCKER_CMD="${DOCKER_CMD} -e '${SERVICE_SOURCE_ENV}=${SERVICE_SOURCE}'"

# mount container tools
DOCKER_CMD="${DOCKER_CMD} -v ${SERVICE_TOOLS_SOURCE}:${SERVICE_TOOLS}:ro"
DOCKER_CMD="${DOCKER_CMD} -e '${SERVICE_TOOLS_ENV}=${SERVICE_TOOLS}'"


######################
# options
######################
# hostname
if [ "${HOST_NAME}" ]; then
    DOCKER_CMD="${DOCKER_CMD} -h ${HOST_NAME}"
else
    DOCKER_CMD="${DOCKER_CMD} -h ${REF_NAME}"
fi
# ports
for PORT in ${PORTS}; do
    if echo "${PORT}" | grep -q '^[0-9][0-9]*\:[0-9][0-9]*$'; then
        DOCKER_CMD="${DOCKER_CMD} -p ${PORT}"
    fi
done

# env variables
for ENV in ${ENVS}; do
    DOCKER_CMD="${DOCKER_CMD} -e '${ENVS}'"
done


# interactive
if [ "${INTERACTIVE_HAS_VALUE}" ]; then
    DOCKER_CMD="${DOCKER_CMD} -t -i"
else
    DOCKER_CMD="${DOCKER_CMD} -d"
fi


######################
# final
######################
DOCKER_CMD="${DOCKER_CMD} ${REF_NAME}"

# for interactive, run shell
if [ "${INTERACTIVE_HAS_VALUE}" ]; then
    DOCKER_CMD="${DOCKER_CMD} /bin/sh"
fi

echo "* Running container ${REF_NAME}..."
echo 
echo ${DOCKER_CMD}
echo

if ! eval ${DOCKER_CMD}; then
    echo "! There were errors Running the command." >&2
    exit 21
fi

exit 0