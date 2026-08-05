# =========================================================
# Dockerfile — University of Lucknow ERP
# Base: Apache Tomcat 10.1 + Java 17
# Render.com compatible (dynamic PORT)
# =========================================================

FROM tomcat:10.1-jdk17-temurin

LABEL maintainer="Manjeet Singh"
LABEL description="University of Lucknow ERP System"

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy app to ROOT context (no /CollegeERP/ prefix needed)
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# Copy MySQL JDBC driver to Tomcat lib
COPY WebContent/WEB-INF/lib/mysql-connector-j.jar /usr/local/tomcat/lib/

# Copy startup script (handles dynamic PORT from Render)
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Environment variables (Railway MySQL — overridden by Render env vars)
ENV DB_HOST=altaria.proxy.rlwy.net
ENV DB_PORT=17613
ENV DB_NAME=railway
ENV DB_USER=root
ENV DB_PASS=DSSZvuVZgEvvUpackNOhnnnrPPnuuaLJ

# Render uses dynamic PORT — startup script sets it
EXPOSE 8080

CMD ["/usr/local/bin/start.sh"]
