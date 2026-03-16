FROM maven:3.6.3-openjdk-8

EXPOSE 8080

# Use local file as database - who cares
ENV DB_DIALECT HSQLDB
ENV DB_URL jdbc:hsqldb:file:lavagna
ENV DB_USER sa
ENV DB_PASS ""
ENV SPRING_PROFILE dev

# Build from lavagna project
COPY . /app
WORKDIR /app
RUN mvn clean package

# Execute the web archive
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
