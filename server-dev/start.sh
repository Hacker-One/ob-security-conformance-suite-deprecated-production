#!/bin/sh

echo "start server"

project=/server

echo $project

cd $project

java -D'fintechlabs.base_url=https://localhost:8443' -D'spring.data.mongodb.uri=mongodb://'$MONGODB_USERNAME':'$MONGODB_PASSWORD'@'$MONGODB_SERVICE_NAME'/admin' -D'oauth.introspection_url=http://'$OBPTESTAUTH_SERVICE_NAME'/introspect' -jar fapi-test-suite.jar --fintechlabs.devmode=true  --fintechlabs.startredir=true
