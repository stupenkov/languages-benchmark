# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Install required packages for Native AOT
RUN apk add --no-cache clang gcc musl-dev make

# Copy the project file
COPY WebSlim/WebSlim.csproj ./WebSlim/

# Restore dependencies
RUN dotnet restore ./WebSlim/WebSlim.csproj

# Copy the source code
COPY WebSlim/. ./WebSlim/

# Build the application with AOT compilation
WORKDIR /app/WebSlim
RUN dotnet publish -c Release -r linux-musl-x64 \
    -o out \
    --self-contained true \
    -p:PublishAot=true \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -p:LinkNativeDependencies=true \
    -p:IncludeNativeLibrariesForSelfExtract=false \
    -p:DebuggerSupport=false

# Create a minimal runtime image
FROM alpine AS runtime

# Set the working directory inside the container
WORKDIR /app

ENV ASPNETCORE_URLS=http://0.0.0.0:5000
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

# Copy the published application from the build stage
COPY --from=build /app/WebSlim/out/appsettings.json ./
COPY --from=build /app/WebSlim/out/WebSlim ./

# Set the entry point to the native executable
ENTRYPOINT ["./WebSlim"]
