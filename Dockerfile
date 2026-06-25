FROM tomcat:9.0-jdk17

# Instalar Ant
RUN apt-get update && apt-get install -y ant

# Directorio de trabajo
WORKDIR /app

# Copiar todo el proyecto
COPY . .

# Compilar proyecto Ant
RUN ant clean
RUN ant

# Buscar WAR en posibles rutas de NetBeans Ant
RUN find . -name "*.war"

# Copiar WAR (NetBeans suele usar build/web o dist)
RUN cp build/*.war /usr/local/tomcat/webapps/ROOT.war || \
    cp dist/*.war /usr/local/tomcat/webapps/ROOT.war || \
    cp -r build/web/* /usr/local/tomcat/webapps/ROOT/

# Exponer Tomcat
EXPOSE 8080

# Ejecutar Tomcat
CMD ["catalina.sh", "run"]