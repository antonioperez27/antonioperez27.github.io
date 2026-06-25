FROM tomcat:9.0-jdk21

RUN apt-get update && apt-get install -y ant wget unzip

WORKDIR /app
COPY . .

# Descargar NetBeans Ant libs (CopyLibs)
RUN mkdir -p /opt/netbeans-ant \
 && wget https://repo1.maven.org/maven2/org-netbeans-modules-java-j2seproject-copylibstask/RELEASE130/org-netbeans-modules-java-j2seproject-copylibstask-RELEASE130.jar \
 -O /opt/netbeans-ant/copylibs.jar

# Pasar classpath a Ant
RUN ant \
 -Dlibs.CopyLibs.classpath=/opt/netbeans-ant/copylibs.jar \
 -Dj2ee.server.home=/usr/local/tomcat \
 clean war

RUN ant \
 -Dlibs.CopyLibs.classpath=/opt/netbeans-ant/copylibs.jar \
 -Dj2ee.server.home=/usr/local/tomcat \
 war

RUN cp dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]