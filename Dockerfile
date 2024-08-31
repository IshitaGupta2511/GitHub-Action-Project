# Stage 1: Build the Java application
FROM amazonlinux:latest AS builder

# Install Java and Maven
RUN yum update -y &&  yum install -y java-11-amazon-corretto-devel.x86_64 maven

# Copy application source code
COPY . /mnt/student-ui

# Set working directory
WORKDIR /mnt/student-ui

# Package the application
RUN mvn package

# Stage 2: Deploy the application with Tomcat
FROM tomcat:latest AS tomcat

# Copy the WAR file from the build stage to Tomcat's webapps directory
COPY --from=builder /mnt/student-ui/target/*.war /usr/local/tomcat/webapps/

# Stage 3: Set up Nginx as a reverse proxy
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for Nginx
EXPOSE 80

# Set the entrypoint to start Nginx
CMD ["nginx", "-g", "daemon off;"]
