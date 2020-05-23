#!/usr/bin/env bash

name=$1
surname=$2
email=$3

curl -u guest:guest -H "content-type:application/json" -X POST \
    -d'{"properties":{"delivery_mode":2},"routing_key":"product.queue.log","payload":"{\"first_name\": \"'${name}'\",\"last_name\": \"'${surname}'\",\"email\": \"'${email}'\"}","payload_encoding":"string"}' \
    http://rabbitmq:15672/api/exchanges/%2f/product.exchange/publish > /dev/null

sleep 1