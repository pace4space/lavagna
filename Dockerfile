FROM maven:3.6.3-openjdk-8

EXPOSE 8080

# Build from project files
COPY project /app
WORKDIR /app
RUN mvn clean package -DskipTests

# Use bash /dev/tcp for database readiness check (no external tools needed)

# Use local file as database - who cares
ENV DB_DIALECT MYSQL
ENV DB_URL jdbc:mysql://mysql:3306/lavagna?autoReconnect=true&useSSL=false
ENV DB_USER sa
ENV DB_PASS ""
ENV SPRING_PROFILE dev

# Execute the web archive
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
