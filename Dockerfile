FROM tomcat:9.0-jdk21

RUN apt-get update && apt-get install -y ant wget unzip

WORKDIR /app

COPY . .

RUN mkdir -p /opt/netbeans-ant \
 && wget https://repo1.maven.org/maven2/org-netbeans-modules-java-j2seproject-copylibstask/RELEASE113/org-netbeans-modules-java-j2seproject-copylibstask-RELEASE113.jar \
 -O /opt/netbeans-ant/copylibs.jar

RUN ant \
 -Dlibs.CopyLibs.classpath=/opt/netbeans-ant/copylibs.jar \
 -Dj2ee.server.home=/usr/local/tomcat \
 clean war

RUN ant \
 -Dlibs.CopyLibs.classpath=/opt/netbeans-ant/copylibs.jar \
 -Dj2ee.server.home=/usr/local/tomcat \
 war

# Copiar WAR a Tomcat
RUN cp dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]