FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["Directory.Packages.props", "./"]
COPY ["Homelab Hub/Homelab Hub.csproj", "Homelab Hub/"]
COPY ["Homelab Hub.Browser/Homelab Hub.Browser.csproj", "Homelab Hub.Browser/"]
RUN dotnet restore "Homelab Hub.Browser/Homelab Hub.Browser.csproj"

COPY ["Homelab Hub/", "Homelab Hub/"]
COPY ["Homelab Hub.Browser/", "Homelab Hub.Browser/"]
RUN dotnet publish "Homelab Hub.Browser/Homelab Hub.Browser.csproj" \
    -c Release \
    -o /app/publish \
    --no-restore

FROM nginx:alpine AS final
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/publish/wwwroot /usr/share/nginx/html

EXPOSE 80
