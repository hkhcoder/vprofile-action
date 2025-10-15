# Use a specific version of Tomcat as base image
FROM tomcat:9.0

# Expose port 8080 to access the application
EXPOSE 8080

# Remove default webapps (optional, to keep it clean)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat's webapps directory
COPY target/maven-cloudaseem-app.war /usr/local/tomcat/webapps/maven-cloudaseem-app.war
