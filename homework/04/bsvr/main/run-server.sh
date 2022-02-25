#!/bin/bash

xx=$( ps -ef | grep main | grep :9191 | awk '{ print $2 }'  )

if [ "${xx}" == "" ] ; then
	:
else
	kill ${xx}
	sleep 1
fi

go build
./main --server :9191 &

