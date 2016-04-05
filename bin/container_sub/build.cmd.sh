#/bin/sh

if [ "${DOCKER_FILE_EXISTS}" != "true" ]; then
    echo "! Dockerfile do no exist in this directory." >&2
    exit 21;
fi

echo "* Building image... ${REF_NAME}"
echo
if ! docker build -t ${REF_NAME} .; then
    echo "! Unable to build Image ${REF_NAME}" >&2
    exit 30
fi

echo "* Built image: ${REF_NAME}"

exit 0
