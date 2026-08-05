# =========================================================
# Dockerfile — University of Lucknow ERP (WAR approach)
# More reliable than exploded webapp
# =========================================================

FROM tomcat:10.1-jdk17-temurin

LABEL maintainer="Manjeet Singh"

# Remove ALL default webapps including ROOT
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy WAR as ROOT (no context prefix in URL)
COPY CollegeERP.war /usr/local/tomcat/webapps/ROOT.war

# Copy MySQL JDBC driver to Tomcat global lib
COPY WebContent/WEB-INF/lib/mysql-connector-j.jar /usr/local/tomcat/lib/
COPY WebContent/WEB-INF/lib/jakarta.servlet-api.jar /usr/local/tomcat/lib/

# Change HTTP port 8080 → 10000 (Render.com default)
RUN sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml

# Disable shutdown port (stops health-check false warnings)
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# DB credentials — Railway MySQL (hardcoded as default)
ENV DB_HOST=altaria.proxy.rlwy.net
ENV DB_PORT=17613
ENV DB_NAME=railway
ENV DB_USER=root
ENV DB_PASS=DSSZvuVZgEvvUpackNOhnnnrPPnuuaLJ

EXPOSE 10000

CMD ["catalina.sh", "run"]
