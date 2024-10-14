# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built jar file from the target folder to the container
COPY target/demo-0.0.1-SNAPSHOT.jar /app/demo.jar

# Expose the application's port (update to 9090)
EXPOSE 9090

# Run the application
ENTRYPOINT ["java", "-jar", "/app/demo.jar"]
