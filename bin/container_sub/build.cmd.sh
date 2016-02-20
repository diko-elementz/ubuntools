#/bin/sh


echo "* Building image... ${REF_NAME}"
echo 
if ! docker build -t ${REF_NAME} .; then
    echo "! Unable to build Image ${REF_NAME}" >&2
    exit 30
fi

echo "* Built image: ${REF_NAME}"

exit 0