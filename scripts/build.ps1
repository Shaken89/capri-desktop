$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
dotnet build app/Capri.csproj --configuration Release --output out
if ($LASTEXITCODE -ne 0) { throw 'Compilation failed' }
dotnet run --project tests/PolicyTests.csproj --configuration Release
if ($LASTEXITCODE -ne 0) { throw 'Policy tests failed' }
