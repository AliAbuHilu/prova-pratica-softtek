FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/BankMore.Transferencia.API/BankMore.Transferencia.API.csproj", "src/BankMore.Transferencia.API/"]

RUN dotnet restore "src/BankMore.Transferencia.API/BankMore.Transferencia.API.csproj"
COPY . .
WORKDIR "/src/src/BankMore.Transferencia.API"
RUN dotnet build "BankMore.Transferencia.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BankMore.Transferencia.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BankMore.Transferencia.API.dll"]
