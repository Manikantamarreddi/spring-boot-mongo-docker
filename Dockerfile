FROM maven:3.8.6-openjdk-8 as build

WORKDIR /app
COPY . .
RUN mvn clean package

FROM openjdk:8-alpine
# Required for starting application up.
RUN apk update && apk add /bin/sh
ENV PROJECT_HOME /opt/app
WORKDIR $PROJECT_HOME
COPY --from=build /app/target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar
EXPOSE 8080
CMD ["java" ,"-jar","./spring-boot-mongo.jar"]
