# ----------- Stage 1: Build using Maven -----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy pom first (for caching dependencies)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the jar
RUN mvn clean package -DskipTests

# ----------- Stage 2: Run the app -----------
FROM eclipse-temurin:21-jdk

WORKDIR /app

# Copy jar from builder stage
COPY --from=builder /app/target/javaapp-1.0-SNAPSHOT.jar app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]
