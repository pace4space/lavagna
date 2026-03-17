#!/bin/sh

# Extract host from DB_URL
host=$(echo "$DB_URL" | sed 's|jdbc:mysql://\([^:]*\):.*|\1|')
echo "DEBUG: DB_URL=$DB_URL"
echo "DEBUG: Extracted host=$host"

if [ "${DB_DIALECT}" = "MYSQL" ]; then
  echo "Waiting for MySQL to be ready..."
  until nc -z $host 3306 2>/dev/null; do
    echo "MySQL not ready, retrying in 2s..."
    sleep 2
  done
  echo "MySQL is ready."
fi
# while ! (echo > /dev/tcp/"$host"/3306) 2>/dev/null; do
#   echo "Waiting for database at $host:3306..."
#   sleep 3
# done

exec java -Xms64m -Xmx128m -Ddatasource.dialect="${DB_DIALECT}" \
  -Ddatasource.url="${DB_URL}" \
  -Ddatasource.username="${DB_USER}" \
  -Ddatasource.password="${DB_PASS}" \
  -Dspring.profiles.active="${SPRING_PROFILE}" \
  -jar ./lavagna-jetty-console.war --headless