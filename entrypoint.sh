#!/bin/bash

# Copy built static files to shared volume
cp -r target/lavagna/* /app/static/

# Extract host from DB_URL
host=$(echo "$DB_URL" | sed 's|jdbc:mysql://\([^:]*\):.*|\1|')

while ! (echo > /dev/tcp/"$host"/3306) 2>/dev/null; do
  echo "Waiting for database at $host:3306..."
  sleep 3
done

exec java -Xms64m -Xmx128m -Ddatasource.dialect="${DB_DIALECT}" \
  -Ddatasource.url="${DB_URL}" \
  -Ddatasource.username="${DB_USER}" \
  -Ddatasource.password="${DB_PASS}" \
  -Dspring.profiles.active="${SPRING_PROFILE}" \
  -jar target/lavagna-jetty-console.war --headless