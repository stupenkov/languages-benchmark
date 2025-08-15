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

# Build the application
WORKDIR /app/HelloWorld
RUN dotnet build -c Release -o out

# Create a runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app/HelloWorld/out ./

# Set the entry point
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
