FROM tomcat:9.0-jdk21

# Instalar Ant
RUN apt-get update && apt-get install -y ant

# Directorio de trabajo
WORKDIR /app

# Copiar proyecto
COPY . .

# Compilar WAR con propiedad j2ee.server.home
RUN ant -Dj2ee.server.home=/usr/local/tomcat clean war
RUN ant -Dj2ee.server.home=/usr/local/tomcat war

# Copiar WAR al Tomcat
RUN cp dist/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponer puerto
EXPOSE 8080

# Ejecutar Tomcat
CMD ["catalina.sh", "run"]