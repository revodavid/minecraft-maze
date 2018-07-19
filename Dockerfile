FROM java
MAINTAINER davidsmi@microsoft.com

## Prepare folder for the Minecraft stuff
RUN mkdir -p /minecraft

## Download Spigot build tools
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -P /minecraft/

## Build the Spigot server
RUN cd /minecraft && java -jar BuildTools.jar

## Symlink for the built Spigot server
RUN ln -s /minecraft/spigot*.jar /minecraft/spigot.jar

## Accept EULA
RUN echo "eula=true" > /minecraft/eula.txt

## Options
RUN echo "gamemode=1" >> /minecraft/server.properties
RUN echo "force-gamemode=true" >> /minecraft/server.properties
RUN echo "level-seed=12345" >> /minecraft/server.properties

## Download and install the RaspberryJuice plugin for API access
RUN mkdir -p /minecraft/plugins \
    && wget https://github.com/zhuowei/RaspberryJuice/archive/master.zip \
    && unzip -p master.zip RaspberryJuice-master/jars/raspberryjuice-1.9.jar > /minecraft/plugins/raspberryjuice-1.9.jar

## Open up API port
EXPOSE 4711
## Open up Game port
EXPOSE 25565

## Start the server
CMD cd /minecraft; java -Xms512M -Xmx1G -XX:+UseConcMarkSweepGC -jar spigot.jar
