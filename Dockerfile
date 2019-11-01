FROM adoptopenjdk/openjdk11-openj9:x86_64-debian-jdk-11.0.5_10_openj9-0.17.0
MAINTAINER http://www.uv.es/twcam

COPY opencv-install.sh opencv-install.sh

RUN chmod +x opencv-install.sh && sync && ./opencv-install.sh 

USER app 
WORKDIR /home/app
CMD bash
