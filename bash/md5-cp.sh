#!/bin/sh

export ORIGIN=$1
export DESTINATION=$2

#cópia simples
rsync -av ${ORIGIN} ${DESTINATION}

#checa checksun
rsync -cavn ${ORIGIN} ${DESTINATION}
