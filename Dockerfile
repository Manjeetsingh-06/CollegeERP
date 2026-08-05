# =========================================================
# Dockerfile — University of Lucknow ERP
# Render.com + Railway MySQL compatible
# =========================================================

FROM tomcat:10.1-jdk17-temurin

LABEL maintainer="Manjeet Singh"

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy app to ROOT context
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# Copy MySQL JDBC driver
COPY WebContent/WEB-INF/lib/mysql-connector-j.jar /usr/local/tomcat/lib/

# DB environment variables (hardcoded as fallback)
ENV DB_HOST=altaria.proxy.rlwy.net
ENV DB_PORT=17613
ENV DB_NAME=railway
ENV DB_USER=root
ENV DB_PASS=DSSZvuVZgEvvUpackNOhnnnrPPnuuaLJ

# Fix port for Render.com — Render injects PORT env variable
# Use shell form CMD so $PORT is evaluated at runtime
EXPOSE 8080

# Inline port fix — no external script needed (avoids CRLF issue)
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'\"${PORT:-8080}\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
