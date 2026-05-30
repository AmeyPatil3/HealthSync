# Use the official Tomcat 9 image with OpenJDK 11 (which contains the JDK with javac)
FROM tomcat:9.0-jdk11-openjdk-slim

LABEL maintainer="Amey Patil"

# Copy local library JARs to Tomcat shared libraries
COPY lib/mysql-connector-j-9.1.0.jar /usr/local/tomcat/lib/
COPY lib/servlet-api.jar /usr/local/tomcat/lib/

# Copy the entire workspace into Tomcat webapps under context path '/healthsync'
COPY . /usr/local/tomcat/webapps/healthsync/

# Create the classes directory and compile Java servlets inside the container
RUN mkdir -p /usr/local/tomcat/webapps/healthsync/WEB-INF/classes && \
    javac -cp "/usr/local/tomcat/webapps/healthsync/lib/*:/usr/local/tomcat/webapps/healthsync/WEB-INF/lib/*" \
          -d /usr/local/tomcat/webapps/healthsync/WEB-INF/classes \
          /usr/local/tomcat/webapps/healthsync/servlet/*.java

# Clean up source code, Docker configs, and build files to keep the container lightweight
RUN rm -rf /usr/local/tomcat/webapps/healthsync/servlet \
           /usr/local/tomcat/webapps/healthsync/Dockerfile \
           /usr/local/tomcat/webapps/healthsync/docker-compose.yml \
           /usr/local/tomcat/webapps/healthsync/build \
           /usr/local/tomcat/webapps/healthsync/schema.sql \
           /usr/local/tomcat/webapps/healthsync/README.md \
           /usr/local/tomcat/webapps/healthsync/deploy.md \
           /usr/local/tomcat/webapps/healthsync/free_deployment_guide.md \
           /usr/local/tomcat/webapps/healthsync/render_deployment_guide.md

EXPOSE 8080
CMD ["catalina.sh", "run"]
