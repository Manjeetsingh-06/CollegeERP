# =========================================================
# Dockerfile — University of Lucknow ERP
# Render.com compatible — Port 10000
# =========================================================

FROM tomcat:10.1-jdk21-temurin

LABEL maintainer="Manjeet Singh"

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Change HTTP port 8080 → 10000 (Render.com default)
RUN sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml

# Disable shutdown port (prevents health-check false warnings)
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy WAR — Tomcat auto-deploys as ROOT context (no /CollegeERP/ prefix)
COPY CollegeERP.war /usr/local/tomcat/webapps/ROOT.war

# Only MySQL connector — servlet-api already provided by Tomcat!
COPY WebContent/WEB-INF/lib/mysql-connector-j.jar /usr/local/tomcat/lib/

# DB credentials — Railway MySQL
ENV DB_HOST=altaria.proxy.rlwy.net
ENV DB_PORT=17613
ENV DB_NAME=railway
ENV DB_USER=root
ENV DB_PASS=DSSZvuVZgEvvUpackNOhnnnrPPnuuaLJ

EXPOSE 10000

CMD ["catalina.sh", "run"]
