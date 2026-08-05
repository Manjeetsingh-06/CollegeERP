# =========================================================
# Dockerfile — University of Lucknow ERP
# Render.com compatible — Port 10000 (Render default)
# =========================================================

FROM tomcat:10.1-jdk17-temurin

LABEL maintainer="Manjeet Singh"

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Change Tomcat HTTP port from 8080 → 10000 (Render default)
RUN sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml

# Disable shutdown port (prevents Render health-check warnings)
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy app to ROOT context
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# Copy MySQL JDBC driver
COPY WebContent/WEB-INF/lib/mysql-connector-j.jar /usr/local/tomcat/lib/

# DB credentials — Railway MySQL
ENV DB_HOST=altaria.proxy.rlwy.net
ENV DB_PORT=17613
ENV DB_NAME=railway
ENV DB_USER=root
ENV DB_PASS=DSSZvuVZgEvvUpackNOhnnnrPPnuuaLJ

EXPOSE 10000

CMD ["catalina.sh", "run"]
