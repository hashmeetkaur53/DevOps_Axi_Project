# Build stage
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /app

COPY ./src ./src
RUN dotnet restore ./src/SuperService.csproj
RUN dotnet publish ./src/SuperService.csproj -c Release -o out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/out .

EXPOSE 80
ENTRYPOINT ["dotnet", "SuperService.dll"]

