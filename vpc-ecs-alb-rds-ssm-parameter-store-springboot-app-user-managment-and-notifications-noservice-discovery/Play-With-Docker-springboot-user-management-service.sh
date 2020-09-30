#!/bin/bash



# Create a network
docker network create springboot --attachable

# Mariadb Setup
docker volume create mariadb
docker run --name mariadb -e MARIADB_DATABASE="springbootdb" -e MARIADB_ROOT_PASSWORD="quickbooks2018" -v mariadb:/bitnami --network="springboot" --restart unless-stopped -d bitnami/mariadb:latest


# Phpmyadmin Setup
docker run --name phpmyadmin --network="springboot" --link mariadb:db -id -p 8080:80 --restart unless-stopped phpmyadmin/phpmyadmin


# User_Management Microservice Setup
docker run --name user-management --network="springboot" -e AWS_RDS_HOSTNAME="mariadb" -e NOTIFICATION_SERVICE_HOST="user-management" -e NOTIFICATION_SERVICE_PORT=80 -e AWS_RDS_PORT=3306 -e AWS_RDS_DB_NAME="springbootdb" -e AWS_RDS_USERNAME=root -e AWS_RDS_PASSWORD="quickbooks2018" --link mariadb:db -p 8095:8095 -p 80:8095 --restart unless-stopped -id quickbooks2018/microservice-user-management:latest


#Health Check  ---> /usermgmt/health-status
#END