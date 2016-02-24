#!/bin/sh


######################
# load defaults
######################
. "${SUBCOMMAND_DIR}/docker_defaults.sh"

######################
# options
######################
COMMAND_OPTIONS="

# rebuild image
-r REBUILD 0

# assign hostname
-h HOST_NAME 1

# assign port
-p PORTS 1

# assign environment variable
-e ENVS 1

# interactive mode
-i INTERACTIVE 0

# output mode
-o OUTPUT 0

"


. "${SUBCOMMAND_DIR}/command_options_process.sh" $*


######################
# stop container
######################
container stop || exit $?


######################
# rebuild image
######################
IMAGES=$(docker images -q ${REF_NAME})
if [ "${IMAGES}ker" ] && [ "${REBUILD_HAS_VALUE}" ]; then
    container unbuild || exit $?
fi


######################
# find/create image
######################
IMAGES=$(docker images -q ${REF_NAME})
if [ ! "${IMAGES}" ]; then
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
    
elif [ "${OUTPUT_HAS_VALUE}" ]; then
    DOCKER_CMD="${DOCKER_CMD} -t"
    
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
