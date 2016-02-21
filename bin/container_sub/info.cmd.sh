#!/bin/sh


######################
# load defaults
######################
. "${SUBCOMMAND_DIR}/docker_defaults.sh"

######################
# options
######################
COMMAND_OPTIONS="
-n SHOW_NAME 0
-d SHOW_DOCKERFILE 0

# minimal
-m SHOW_MINIMAL 0
--minimal SHOW_MINIMAL 0

# show active
-a SHOW_ACTIVE 0
--active SHOW_ACTIVE 0

# show hostname
-h SHOW_HOSTNAME 0
--host SHOW_HOSTNAME 0

# show volume size
-v SHOW_VOLUME_SIZE 0
--size SHOW_VOLUME_SIZE 0

# history
--history SHOW_HISTORY 0

# logs
-l SHOW_LOGS 0
--logs SHOW_LOGS 0

# stats
-s SHOW_STATS 0
--stats SHOW_STATS 0

# ip address
-i SHOW_IP 0
--ip SHOW_IP 0

"
. "${SUBCOMMAND_DIR}/command_options_process.sh" $*

######################
# get info
######################
IMAGES=$(docker images -q "${REF_NAME}")
CONTAINERS=$(docker ps -a -q -f name=${REF_NAME})
IS_ACTIVE=$(docker ps -q -f name=${REF_NAME})

######################
# get info of image
######################
if [ "${IMAGES}" ]; then
    IMAGE_HISTORY=$(docker history --no-trunc "${IMAGES}")
fi

######################
# get info container
######################
if [ "${CONTAINERS}" ]; then
    if [ "${SHOW_STATS_HAS_VALUE}" ]; then
        CONTAINER_STATS=$(docker stats --no-stream "${CONTAINERS}")
    fi
fi

######################
# get info of
# active container
###################### 
if [ "${IS_ACTIVE}" ]; then
    
    SHOW_ACTIVE="${IS_ACTIVE}"
    
    CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${IS_ACTIVE}")
    CONTAINER_HOSTNAME=$(docker inspect -f '{{.Config.Hostname}}' "${IS_ACTIVE}")
    
    if [ "${SHOW_LOGS_HAS_VALUE}" ]; then
        CONTAINER_LOGS=$(docker logs "${IS_ACTIVE}")
    fi
    
fi


######################
# show info
######################
if [ "${SHOW_MINIMAL_HAS_VALUE}" ]; then
    
    if [ "${SHOW_NAME_HAS_VALUE}" ]; then
        echo "${REF_NAME}"
    fi
    
    if [ "${SHOW_DOCKERFILE_HAS_VALUE}" ]; then
        echo "${DOCKERFILE}"
    fi
    
    if [ "${SHOW_ACTIVE_HAS_VALUE}" ]; then
        echo "${IS_ACTIVE}"
    fi
    
    if [ "${SHOW_HISTORY_HAS_VALUE}" ]; then
        echo "${IMAGE_HISTORY}"
    fi
    
    if [ "${SHOW_LOGS_HAS_VALUE}" ]; then
        echo "${CONTAINER_LOGS}"
    fi
    
    if [ "${SHOW_STATS_HAS_VALUE}" ]; then
        echo "${CONTAINER_STATS}"
    fi
    
    if [ "${SHOW_IP_HAS_VALUE}" ]; then
        echo "${CONTAINER_IP}"
    fi
    
    if [ "${SHOW_HOSTNAME_HAS_VALUE}" ]; then
        echo "${CONTAINER_HOSTNAME}"
    fi
    
else
    # profile
    echo "Name: ${REF_NAME}"
    echo "Docker file: ${DOCKERFILE}"
    echo "IP Adress: ${CONTAINER_IP}"
    echo "Hostname: ${CONTAINER_HOSTNAME}"
    echo "Disk Usage: ${SHOW_VOLUME_SIZE}"
    
    if [ "${IMAGES}" ]; then
        echo "Image ID: ${IMAGES}"
    else
        echo "Image ID: <not built>"
    fi
    
    if [ "${CONTAINERS}" ]; then
        echo "Container ID: ${CONTAINERS}"
    else
        echo "Container ID: <not created>"
    fi
    
    if [ "${IS_ACTIVE}" ]; then
        echo "Container Active: yes"
    else
        echo "Container Active: no"
    fi
    
    if [ "${SHOW_STATS_HAS_VALUE}" ]; then
        echo
        if [ "${CONTAINER_STATS}" ]; then
            echo "Stats:"
            echo "${CONTAINER_STATS}"
        else
            echo "<container stats not available>"
        fi
        echo
    fi
    
    if [ "${SHOW_LOGS_HAS_VALUE}" ]; then
        echo
        if [ "${CONTAINER_LOGS}" ]; then
            echo "Logs:"
            echo "${CONTAINER_LOGS}"
        else
            echo "<container logs not available>"
        fi
        echo
    fi
    
    if [ "${SHOW_HISTORY_HAS_VALUE}" ]; then
        echo
        if [ "${IMAGE_HISTORY}" ]; then
            echo "Image History:"
            echo "${IMAGE_HISTORY}"
        else
            echo "<image history not available>"
        fi
        echo
    fi
    
fi

exit 0
