# Stage 1: Builder - compile and package
FROM maven:3.6.3-openjdk-8 AS builder

WORKDIR /app
COPY project .

# Run build, creates target/lavagna-jetty-console.war
RUN mvn clean package -DskipTests
RUN mvn stampo:build
# RUN mvn stampo:build -DoutputDir=/stampo/stampo-build/lavagna/help

COPY entrypoint.sh .


# Stage 2: Runtime - lightweight final image
FROM eclipse-temurin:8-jre-alpine

EXPOSE 8080
WORKDIR /app

# Copy WAR (and help files) from builder stage
COPY --from=builder /app/target/lavagna-jetty-console.war .
# COPY --from=builder /stampo/stampo-build/lavagna/help /app/help
# COPY target/lavagna/help /app/help
COPY --from=builder /app/target/lavagna/help /app/docs-dist

# Copy entrypoint script from builder stage
# COPY --from=builder /app/entrypoint.sh .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
