@echo off
setlocal

:: Create directories if they don't exist
if not exist "lib" mkdir lib
if not exist "bin" mkdir bin

:: Download JUnit 5 if it doesn't exist
if not exist "lib\junit-jupiter-api-5.10.1.jar" (
	echo Downloading JUnit 5...
	powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-api/5.10.1/junit-jupiter-api-5.10.1.jar' -OutFile 'lib\junit-jupiter-api-5.10.1.jar'}"
	powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.10.1/junit-jupiter-engine-5.10.1.jar' -OutFile 'lib\junit-jupiter-engine-5.10.1.jar'}"
	powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/junit/platform/junit-platform-commons/1.10.1/junit-platform-commons-1.10.1.jar' -OutFile 'lib\junit-platform-commons-1.10.1.jar'}"
	powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/junit/platform/junit-platform-engine/1.10.1/junit-platform-engine-1.10.1.jar' -OutFile 'lib\junit-platform-engine-1.10.1.jar'}"
	powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/opentest4j/opentest4j/1.3.0/opentest4j-1.3.0.jar' -OutFile 'lib\opentest4j-1.3.0.jar'}"
	powershell -Command "& {Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.1/junit-platform-console-standalone-1.10.1.jar' -OutFile 'lib\junit-platform-console-standalone-1.10.1.jar'}"
)

:: Set classpath for compilation
set CLASSPATH=lib\junit-jupiter-api-5.10.1.jar;lib\junit-platform-commons-1.10.1.jar;lib\opentest4j-1.3.0.jar

:: Compile the code
echo Compiling...
javac -d bin -cp "%CLASSPATH%" src/*.java

if errorlevel 1 (
	echo Compilation failed!
	exit /b 1
)

:: Set classpath for running tests
set TEST_CLASSPATH=bin;%CLASSPATH%;lib\junit-jupiter-engine-5.10.1.jar;lib\junit-platform-engine-1.10.1.jar

:: Run the tests using JUnit Platform Console Launcher
echo Running tests...
java -jar lib\junit-platform-console-standalone-1.10.1.jar -cp "%TEST_CLASSPATH%" --scan-classpath

endlocal 