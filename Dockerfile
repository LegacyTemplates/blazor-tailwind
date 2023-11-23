FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY ./ .
RUN dotnet restore

ARG DEPLOY_API
ARG DEPLOY_CDN

WORKDIR /app/MyApp.Client
RUN npm run ui:build
WORKDIR /app/MyApp
RUN dotnet publish -c release /p:DEPLOY_API=${DEPLOY_API} /p:DEPLOY_CDN=${DEPLOY_CDN} /p:APP_TASKS=prerender -o /out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /out .
ENTRYPOINT ["dotnet", "MyApp.dll"]
