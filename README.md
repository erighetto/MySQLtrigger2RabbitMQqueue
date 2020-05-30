# MySQL trigger to RabbitMQ queue

Can we publish a message via a database trigger?  
Yes you can.  

With some Hackish Pranks & Tricks by the way.  

cfr: https://github.com/ssimicro/lib_mysqludf_amqp  

See in action running:  
    bash run.sh  

Then look at http://localhost:15672/#/queues/%2F/contacts.queue.log for the messages