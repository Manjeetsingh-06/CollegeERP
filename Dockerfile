# =========================================================
# Dockerfile — University of Lucknow ERP
# Base: Apache Tomcat 10.1 + Java 17
# =========================================================

FROM tomcat:10.1-jdk17-temurin

LABEL maintainer="Manjeet Singh"
LABEL description="University of Lucknow ERP System"

# Remove default Tomcat webapps (ROOT, examples, docs)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy compiled WAR (or exploded webapp) into Tomcat
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# Copy MySQL JDBC driver to Tomcat lib (for global availability)
COPY WebContent/WEB-INF/lib/mysql-connector-j.jar /usr/local/tomcat/lib/

# ---- Environment variables (will be overridden by Railway) ----
# These are defaults — Railway will inject real DB_* values
ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=college_erp
ENV DB_USER=root
ENV DB_PASS=Manjeet@2007

# Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
