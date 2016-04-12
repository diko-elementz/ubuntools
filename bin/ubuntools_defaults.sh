#!/bin/sh

CURRENT_DIR=$(pwd)
TOOLS_DIR=$(dirname $(readlink -m $0))
REF_NAME=$(basename $CURRENT_DIR)
CMD_PARAM_PROCESS="${TOOLS_DIR}/command_options_process.sh"
COMMAND=$1


export CURRENT_DIR
export TOOLS_DIR
export REF_NAME
export CMD_PARAM_PROCESS
export COMMAND
