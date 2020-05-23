#!/usr/bin/env bash

name=$1
surname=$2
email=$3

curl -u guest:guest -H 'content-type:application/json' -X POST \
    -d'{"properties":{},"routing_key":"contacts.queue.update","payload":"{\"first_name\": \"'${first_name}'\",\"last_name\": \"'${last_name}'\",\"email\": \"'${email}'\"}","payload_encoding":"string"}' 
    'http://rabbitmq:15672/api/exchanges/%2f/contacts.exchange/publish'

sleep 1