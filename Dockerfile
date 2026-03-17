# Stage 1: Builder - compile and package
FROM maven:3.6.3-openjdk-8 AS builder

WORKDIR /app
COPY project .

# Run build, creates target/lavagna-jetty-console.war
RUN mvn clean package -DskipTests

COPY entrypoint.sh .


# Stage 2: Runtime - lightweight final image
FROM eclipse-temurin:8-jre-alpine

EXPOSE 8080
WORKDIR /app

# Copy only the built WAR from builder stage
COPY --from=builder /app/target/lavagna-jetty-console.war .

# Copy entrypoint script from builder stage
COPY --from=builder /app/entrypoint.sh .
RUN chmod +x entrypoint.sh

# Database config
# ENV DB_DIALECT MYSQL
# ENV DB_URL jdbc:mysql://mysql:3306/lavagna?autoReconnect=true&useSSL=false
# ENV DB_USER sa
# ENV DB_PASS ""
# ENV SPRING_PROFILE dev

ENTRYPOINT ["./entrypoint.sh"]
