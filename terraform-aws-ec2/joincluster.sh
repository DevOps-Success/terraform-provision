#!/bin/bash

#Restart Mongodb server
sudo systemctl start mongod.service



#Restart Ops Manager Agent
sudo systemctl start mongodb-mms-automation-agent.service


#Add node to cluster
add_slave(){
    mongo --host MASTER_IP --port 27017  --authenticationDatabase "admin" -u "admin-monitor" -p ABC@1234567 --eval 'rs.add("$ip")'
}
add_slave