# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Install required packages for Native AOT
RUN apk add --no-cache clang gcc musl-dev make

# Copy the project file
COPY HelloWorld/HelloWorld.csproj ./HelloWorld/

# Restore dependencies
RUN dotnet restore ./HelloWorld/HelloWorld.csproj

# Copy the source code
COPY HelloWorld/. ./HelloWorld/

# Build the application with AOT compilation
WORKDIR /app/HelloWorld
RUN dotnet publish -c Release -r linux-musl-x64 \
    -o out --self-contained true \
    -p:PublishAot=true \
    -p:IncludeNativeLibrariesForSelfExtract=false \
    -p:StripSymbols=true \
    -p:LinkNativeDependencies=true

# Create a minimal runtime image
FROM alpine AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/HelloWorld/out ./

# Set the entry point to the native executable
ENTRYPOINT ["./HelloWorld"]
