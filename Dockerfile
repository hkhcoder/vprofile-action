FROM openjdk:11 AS BUILD_IMAGE
RUN apt update && apt install maven -y
COPY ./ testapp-project
RUN cd testapp-project &&  mvn install 

FROM tomcat:9-jre11
LABEL "Project"="Testapp"
LABEL "Author"="George"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE testapp-project/target/testapp-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
