#!/usr/bin/env bash

docker-compose build

docker-compose up -d

echo -ne '#####                     (33%)\r'
sleep 10
echo -ne '#############             (66%)\r'
sleep 10
echo -ne '#######################   (100%)\r'
echo -ne '\n'

curl -i -u guest:guest -H "content-type:application/json" \
-XPUT -d'{"auto_delete":false,"durable":true}' http://localhost:15672/api/queues/%2f/contacts.queue.log

curl -i -u guest:guest -H "content-type:application/json" \
-XPUT -d'{"type":"topic","auto_delete":false,"durable":true,"internal":false,"arguments":{}}' http://localhost:15672/api/exchanges/%2f/contacts.exchange

curl -i -u guest:guest -H "content-type:application/json" \
-XPOST -d'{"destination_type":"queue","routing_key":"contacts.queue.*","arguments":[]}' http://localhost:15672/api/bindings/%2f/e/contacts.exchange/q/contacts.queue.log

docker exec -i acme_mysql mysql -uroot -ppassword  <<< "USE acme;
INSERT INTO contacts (first_name,last_name,email) 
VALUES ('Carine ','Schmitt','carine.schmitt@verizon.net'),
('Jean','King','jean.king@me.com'),
('Peter','Ferguson','peter.ferguson@google.com'),
('Janine ','Labrune','janine.labrune@aol.com'),
('Jonas ','Bergulfsen','jonas.bergulfsen@mac.com'),
('Janine ','Labrune','janine.labrune@aol.com'),
('Susan','Nelson','susan.nelson@comcast.net'),
('Zbyszek ','Piestrzeniewicz','zbyszek.piestrzeniewicz@att.net'),
('Roland','Keitel','roland.keitel@yahoo.com'),
('Julie','Murphy','julie.murphy@yahoo.com'),
('Kwai','Lee','kwai.lee@google.com'),
('Jean','King','jean.king@me.com'),
('Susan','Nelson','susan.nelson@comcast.net'), 
('Roland','Keitel','roland.keitel@yahoo.com');"