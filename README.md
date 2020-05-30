# MySQL trigger to RabbitMQ queue

Can we publish a message to a RabbitMQ queue via a database trigger?  
**Yes you can.**  

*With some Hackish Pranks & Tricks by the way.*  

cfr: https://github.com/ssimicro/lib_mysqludf_amqp  

See in action running on your favourite shell:  

    bash run.sh  

Then look at http://localhost:15672/#/queues/%2F/contacts.queue.log for the published messages.  

## Show me the tricks now

* Read the specific [init queries](queries/init.sql#L28) to set up the triggers into the database
* See the [curl calls](run.sh#L16) to RabbitMQ instance to create the necessary queue and the exchange binding
