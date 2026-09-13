# ==========================================
# 1. BUILD STAGE (Maven & JDK 21)
# ==========================================
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder

WORKDIR /build

# Copy Maven POM and dependency cache layer
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy application source code and compile
COPY src ./src
RUN mvn clean package -DskipTests -B

# ==========================================
# 2. RUNTIME STAGE (Lightweight JRE 21 Alpine)
# ==========================================
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create non-privileged service user
RUN addgroup -S fitbizz && adduser -S fitbizz -G fitbizz
USER fitbizz

# Copy jar from build stage
COPY --from=builder /build/target/*.jar app.jar

# Configuration defaults for Cloud Container Runtime
ENV PORT=7860
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+UseSerialGC -Xss256k -Djava.security.egd=file:/dev/./urandom"

EXPOSE 7860
EXPOSE 8080

# Execute Spring Boot application on dynamic $PORT
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Dserver.port=${PORT:-7860} -jar app.jar"]
