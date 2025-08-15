# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project file
COPY csharp/HelloWorld/HelloWorld.csproj ./HelloWorld/

# Restore dependencies
RUN dotnet restore ./HelloWorld/HelloWorld.csproj

# Copy the source code
COPY csharp/HelloWorld/. ./HelloWorld/

# Build the application with AOT compilation
WORKDIR /app/HelloWorld
RUN dotnet publish -c Release -o out --self-contained true -p:PublishAot=true -p:IncludeNativeLibrariesForSelfExtract=true

# Create a minimal runtime image
FROM mcr.microsoft.com/dotnet/runtime:9.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/HelloWorld/out ./

# Set the entry point to the native executable
ENTRYPOINT ["./HelloWorld"]
