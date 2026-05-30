# Use the official Tomcat 9 image with OpenJDK 11
FROM tomcat:9.0-jdk11-openjdk-slim

# Maintainer info
LABEL maintainer="Amey Patil"

# Copy local library JARs (MySQL connector and servlet APIs) to Tomcat shared libraries
COPY lib/mysql-connector-j-9.1.0.jar /usr/local/tomcat/lib/
COPY lib/servlet-api.jar /usr/local/tomcat/lib/

# Copy the web application files into Tomcat's webapps directory under context path '/newhealth'
COPY . /usr/local/tomcat/webapps/newhealth/

# Clean up unwanted Docker / raw Java source files inside the container deployment folder
RUN rm -rf /usr/local/tomcat/webapps/newhealth/Dockerfile \
           /usr/local/tomcat/webapps/newhealth/servlet \
           /usr/local/tomcat/webapps/newhealth/build \
           /usr/local/tomcat/webapps/newhealth/schema.sql \
           /usr/local/tomcat/webapps/newhealth/README.md

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat Server
CMD ["catalina.sh", "run"]
