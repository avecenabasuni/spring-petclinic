FROM eclipse-temurin:17-jdk AS builder

# Set working dir & copy project
WORKDIR /app
COPY . .

# Build the Spring Boot jar
RUN ./mvnw clean package -DskipTests

# --- Final Image ---
FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Install curl & download OpenTelemetry Java Agent
RUN apt-get update && apt-get install -y curl && \
    curl -L https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.14.0/opentelemetry-javaagent.jar -o opentelemetry-javaagent.jar

# Copy jar from builder image
COPY --from=builder /app/target/spring-petclinic-*.jar app.jar

# Expose port (default Spring Boot)
EXPOSE 8080

# Run app with agent
ENTRYPOINT ["java", "-javaagent:/app/opentelemetry-javaagent.jar", "-jar", "/app/app.jar"]
