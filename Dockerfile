FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && echo "node version: $(node --version)" \
 && echo "npm version: $(npm --version)" \
 && rm -rf /var/lib/apt/lists/*

COPY ./ .
RUN dotnet restore


WORKDIR /app/MyApp.Client
RUN npm cache clean --force
RUN npm install && npm run ui:build
WORKDIR /app/MyApp
RUN dotnet publish -c release /p:DEPLOY_API=${DEPLOY_API} /p:DEPLOY_CDN=${DEPLOY_CDN} /p:APP_TASKS=prerender -o /out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS runtime
WORKDIR /app
COPY --from=build /out .
ENTRYPOINT ["dotnet", "MyApp.dll"]
