#!/bin/sh


CONTAINER=$(container info -a -m)

######################
# load defaults
######################
. "${SUBCOMMAND_DIR}/docker_defaults.sh"

######################
# options
######################
COMMAND_OPTIONS="

# use bin/sh 
-u UNIX_SHELL 0

"

. "${SUBCOMMAND_DIR}/command_options_process.sh" $*


if [ "${UNIX_SHELL_HAS_VALUE}" ]; then
    docker exec -t -i "${CONTAINER}" /bin/sh
else
    docker exec -t -i "${CONTAINER}" /bin/bash
fi
