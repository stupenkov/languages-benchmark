FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
WORKDIR /src
COPY web-runtime.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o /app/out \
    --self-contained false \
    -p:PublishReadyToRun=true
RUN find /app/out -type f -name "*.pdb" -delete && find /app/out -type f -name "*.xml" -delete

FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "web-runtime.dll"]
