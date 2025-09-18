# Use the official .NET SDK image to build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and restore
COPY *.sln ./
COPY Bulky.DataAccess/*.csproj Bulky.DataAccess/
COPY Bulky.Models/*.csproj Bulky.Models/
COPY Bulky.Utility/*.csproj Bulky.Utility/
COPY BulkyWeb/*.csproj BulkyWeb/
RUN dotnet restore

# Copy everything and build
COPY . .
WORKDIR /src/BulkyWeb
RUN dotnet publish -c Release -o /app/publish

# Use ASP.NET runtime for final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "BulkyWeb.dll"]
