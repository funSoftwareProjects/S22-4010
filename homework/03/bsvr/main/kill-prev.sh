#!/bin/bash

xx=$( ps -ef | grep main | grep 127.0.0.1:9191 | awk '{ print $2 }'  )

if [ "${xx}" == "" ] ; then
	:
else
	echo kill ${xx}
	sleep 1
fi

# go build
# ./main --server 127.0.0.1:9191 &

