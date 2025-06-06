#!/bin/bash

# Create directories if they don't exist
mkdir -p lib bin

# Download JUnit 5 if it doesn't exist
if [ ! -f "lib/junit-jupiter-api-5.10.1.jar" ]; then
    echo "Downloading JUnit 5..."
    wget -P lib https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.1/junit-jupiter-api-5.10.1.jar
    wget -P lib https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.10.1/junit-jupiter-engine-5.10.1.jar
    wget -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-commons/1.10.1/junit-platform-commons-1.10.1.jar
    wget -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-engine/1.10.1/junit-platform-engine-1.10.1.jar
    wget -P lib https://repo1.maven.org/maven2/org/opentest4j/opentest4j/1.3.0/opentest4j-1.3.0.jar
    wget -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.1/junit-platform-console-standalone-1.10.1.jar
fi

# Set classpath for compilation
CLASSPATH="lib/junit-jupiter-api-5.10.1.jar:lib/junit-platform-commons-1.10.1.jar:lib/opentest4j-1.3.0.jar"

# Compile the code
echo "Compiling..."
javac -d bin -cp "$CLASSPATH" src/*.java

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

# Set classpath for running tests
TEST_CLASSPATH="bin:$CLASSPATH:lib/junit-jupiter-engine-5.10.1.jar:lib/junit-platform-engine-1.10.1.jar"

# Run the tests using JUnit Platform Console Launcher
echo "Running tests..."
java -jar lib/junit-platform-console-standalone-1.10.1.jar -cp "$TEST_CLASSPATH" --scan-classpath 