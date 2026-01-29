#!/bin/bash

CONTAINER=$1

xhost +local:root

docker exec -it \
    -u $(id -u):$(id -g) \
    ${CONTAINER:=point_lio_unilidar} \
    /bin/bash