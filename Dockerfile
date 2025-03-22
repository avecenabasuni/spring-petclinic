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
ENV OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.nr-data.net
ENV OTEL_EXPORTER_OTLP_HEADERS=api-key=b535d93b44eda24b77a0f3c5278c04cfFFFFNRAL

# Expose port (default Spring Boot)
EXPOSE 8080

# Run app with agent
ENTRYPOINT ["java", "-javaagent:/app/opentelemetry-javaagent.jar", "-Dotel.service.name=spring-petclinic", "-Dotel.exporter.otlp.endpoint=https://otlp.nr-data.net", "-Dotel.exporter.otlp.headers=api-key=b535d93b44eda24b77a0f3c5278c04cfFFFFNRAL", "-jar", "/app/app.jar"]