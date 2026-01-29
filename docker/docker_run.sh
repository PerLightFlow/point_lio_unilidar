#!/bin/bash

declare script_dir=$(cd $(dirname $0); pwd -P)

declare ARGS=$(getopt -o h,c:,d: --long help,code:,data: -n "$0" -- "$@")
# echo ARGS=[$ARGS]
eval set -- "${ARGS}"
# echo formatted parameters=[$@]

declare docker_image_tag="v1.0"
declare docker_image_name="pointlio/unilidar"
declare docker_image="${docker_image_name}:${docker_image_tag}"
declare container_name="point_lio_unilidar"
declare code_dir=""
declare data_dir=""

function Help() {
cat << EOF
docker_run.sh -- help script to run docker

Usage:
    docker_run.sh [-h|--help] [-c|--code] [-d|--data]

    -h|--help           Show help message
    -c|--code           Code directory mount into container
    -d|--data           Data directory mount into container

Example:
    docker_run.sh -c /home/user/ros_ws -d /home/user/data

EOF
}

if [[ $1 ]]; then
    while true;
    do
        case $1 in
            -h|--help)
                Help; exit 0; ;;
            -c|--code)
                code_dir=$2; shift 2; ;;
            -d|--data)
                data_dir=$2; shift 2; ;;
            --)
                shift; break; ;;
            *)
                echo "unrecognized arguments ${@}"
                Help
                exit 1
                ;;
        esac
    done
fi

if [[ $(docker ps -a | grep ${container_name}) ]]; then
    echo "The container '${container_name}' is already runable, start or exec it"
    exit 1
fi

# Build the image if it doesn't exist
if [[ $(docker images | grep ${docker_image_name} | grep ${docker_image_tag}) ]]; then
    echo "The image already exists, no need to rebuild"
else
    echo "Building Docker image: ${docker_image}"
    docker build -t ${docker_image} ${script_dir}
    if [ $? -ne 0 ]; then
        echo "Failed to build Docker image"
        exit 1
    fi
fi

declare volumes=""
if [[ ${code_dir} ]]; then
    volumes="-v ${code_dir}:/home/pointlio/ros_ws"
fi
if [[ ${data_dir} ]]; then
    volumes="${volumes} -v ${data_dir}:/home/pointlio/data"
fi

docker run -it \
    -u $(id -u):$(id -g) \
    --network=host \
    -e HOME=/home/pointlio \
    ${volumes} \
    --name=${container_name} \
    -e "QT_X11_NO_MITSHM=1" \
    -e DISPLAY=unix$DISPLAY \
    --workdir=/home/pointlio \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --env="DISPLAY" \
    --privileged \
    -d ${docker_image}

${script_dir}/docker_into.sh ${container_name}