# This dockerfile is used when running development builds of the server
#
# It is necessary to make selenium work when the server is running on
# localhost - selenium runs on the jvm, so localhost points at the
# spring server, whereas selenium needs to talk to the ingress httpd
FROM reg.qloudhub.com/openjdk:9-jdk-slim

RUN apt-get update && apt-get install redir
COPY target/ /server/
COPY start.sh /server/start.sh
RUN chmod u+x /server
RUN chmod u+x /server/start.sh
RUN chmod u+x /server/fapi-test-suite.jar
CMD ["/server/start.sh"]
