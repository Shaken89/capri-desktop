$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
$csc = "$env:WINDIR\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if (!(Test-Path $csc)) { throw '.NET Framework 4.x compiler required' }
New-Item -ItemType Directory -Force out | Out-Null
$resources = @(Get-ChildItem assets/sprites/*.png | ForEach-Object { "/resource:$($_.FullName),Capri.Sprite.$($_.Name)" })
$resources += '/resource:assets/chip.ico,Capri.Chip.ico'
$resources += '/resource:assets/fonts/ShareTechMono-Regular.ttf,Capri.Font.Mono.ttf'
$sources = @(Get-ChildItem app/*.cs | Where-Object Name -ne 'Setup.cs' | ForEach-Object FullName)
& $csc /nologo /target:winexe /out:out/Capri.exe /win32icon:assets/chip.ico /win32manifest:app/app.manifest /reference:System.Drawing.dll /reference:System.Windows.Forms.dll /reference:System.Runtime.Serialization.dll /reference:System.Net.Http.dll @resources @sources
if ($LASTEXITCODE -ne 0) { throw 'Compilation failed' }
& $csc /nologo /out:out/PolicyTests.exe app/AnimationState.cs tests/PolicyTests.cs
if ($LASTEXITCODE -ne 0) { throw 'Test compilation failed' }
& ./out/PolicyTests.exe
if ($LASTEXITCODE -ne 0) { throw 'Policy tests failed' }
