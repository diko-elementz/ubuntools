#!/bin/sh

######################
# destroy images
######################
IMAGES=$(docker images -q ${REF_NAME})
if [ "${IMAGES}" ]; then
    echo "* Destroying image..."
    if ! docker rmi $(docker images -q ${REF_NAME}); then
        echo "! Unable to destroy image ${REF_NAME}" >&2
        exit 31
    fi
fi
exit 0