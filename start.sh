#!/bin/bash
# Render injects PORT env variable — Tomcat ko usi port pe chalao
PORT=${PORT:-8080}
echo "Starting Tomcat on port: $PORT"

# server.xml mein port replace karo
sed -i "s/port=\"8080\"/port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml

# Tomcat start karo
exec catalina.sh run
