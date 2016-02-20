#!/bin/sh


if [ "${COMMAND_OPTIONS}" ]; then
    
    # assign exportables
    while [ $# -gt 0 ]; do
        OPTION=$1
        shift 1
        
        # find in table
        MATCH=$(echo "${COMMAND_OPTIONS}" | grep -m 1 "^${OPTION}")
        
        if [ "${MATCH}" ]; then
            
            
            # assign exportable
            VARNAME=$(echo ${MATCH} | cut -d' ' -f2)
            VARNAME_HAS_VALUE="${VARNAME}_HAS_VALUE"
            COUNT=$(echo ${MATCH} | cut -d' ' -f3)
            EXPECTED_COUNT="${COUNT}"
            eval 'VALUE=$'${VARNAME}
            FOUND_COUNT=0
            
            while [ $# -gt 0 ] && [ ${COUNT} -gt 0 ]; do
                ARG=$1
                shift 1
                COUNT=$(expr ${COUNT} - 1)
                FOUND_COUNT=$(expr ${FOUND_COUNT} + 1)
                if [ "${VALUE}" ]; then
                    VALUE="${VALUE}
${ARG}"
                else
                    VALUE="${ARG}"
                fi
            done
            
            # assign exportable
            if [ ${FOUND_COUNT} -lt ${EXPECTED_COUNT} ]; then
                eval ${VARNAME_HAS_VALUE}=
            else
                eval ${VARNAME_HAS_VALUE}=true
            fi
            
            # set options found
            if [ "${OPTIONS_FOUND}" ]; then
                OPTIONS_FOUND="${OPTIONS_FOUND} ${OPTION}"
            else
                OPTIONS_FOUND="${OPTION}"
            fi
            
            eval "${VARNAME}='${VALUE}'"
            
            eval export ${VARNAME_HAS_VALUE}
            eval export ${VARNAME}
           
        fi
    done
    
    if [ "${OPTIONS_FOUND}" ]; then
        export OPTIONS_FOUND
    fi
fi

