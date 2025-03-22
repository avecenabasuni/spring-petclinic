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
    curl -L https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v1.29.0/opentelemetry-javaagent.jar -o opentelemetry-javaagent.jar

# Copy jar from builder image
COPY --from=builder /app/target/spring-petclinic-*.jar app.jar

# Runtime ENV vars (override saat docker run)
ENV OTEL_SERVICE_NAME=spring-petclinic
ENV OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.nr-data.net:4317
ENV OTEL_EXPORTER_OTLP_HEADERS=api-key=REPLACE_ME

# Expose port (default Spring Boot)
EXPOSE 8080

# Run app with agent
ENTRYPOINT ["java", "-javaagent:/app/opentelemetry-javaagent.jar", "-Dotel.service.name=${OTEL_SERVICE_NAME}", "-Dotel.exporter.otlp.endpoint=${OTEL_EXPORTER_OTLP_ENDPOINT}", "-Dotel.exporter.otlp.headers=${OTEL_EXPORTER_OTLP_HEADERS}", "-jar", "/app/app.jar"]