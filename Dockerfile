# 1. Build compile image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /build
COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o out

# 2. Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 
LABEL description="Minimal counter app"
LABEL organisation="GBS St.Gallen"
LABEL author="Silvio Dall'Acqua"
WORKDIR /app
COPY --from=build-env /build/out .
ENV ASPNETCORE_URLS=http://*5001
EXPOSE 5001
ENTRYPOINT ["dotnet", "app.dll"]