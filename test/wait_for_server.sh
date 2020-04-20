#!/bin/bash

command='wget -q http://localhost:4000/ -O /dev/null';
server_started_status_code=0;
status=-1;

until [[ $status == $server_started_status_code ]]
do
  sleep 1;
  printf "*"
  eval $command;
  status=$?
done
