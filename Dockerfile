# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["BlazorServerApp.csproj", "./"]
RUN dotnet restore "BlazorServerApp.csproj"

COPY . .
RUN dotnet publish "BlazorServerApp.csproj" -c Release --no-restore -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080

COPY --from=build /app/publish .
USER app
ENTRYPOINT ["dotnet", "BlazorServerApp.dll"]
