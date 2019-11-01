# java-opencv-docker-image

From the base image:
adoptopenjdk/openjdk11-openj9:x86_64-debian-jdk-11.0.5_10_openj9-0.17.0

Installs:
 - OpenCV (to generate .so and .jar for Java)
 - openssh-client (to copy data from other machines)
 - TensorFlow libraries for Java (just in case we neeed that in the future)

This image has been used to start containers that perform image processing and has been used along with RabbitMQ and a Web Server to deploy a full containerized working application in the Master in Web Technologies, Cloud Computing, and Mobile Applications (http://www.uv.es/twcam).

