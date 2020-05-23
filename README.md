# MySQL trigger to RabbitMQ queue

Can we publish a message via a database trigger?  
Yes you can.  

With some Hackish Pranks & Tricks by the way.  

cfr: https://github.com/mysqludf/lib_mysqludf_sys  

Under the hood MySQL trigger a bash script that via curl publish a message calling RabbitMQ api  

See in action running:  
    bash run.sh  

Then look at http://localhost:15672/#/queues/%2F/contacts.queue.log for the messages