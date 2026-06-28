# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

ARG STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip
ARG VC_REDIST_X86_URL=https://aka.ms/vs/17/release/vc_redist.x86.exe
ARG VC_REDIST_X64_URL=https://aka.ms/vs/17/release/vc_redist.x64.exe

WORKDIR C:/tf2

RUN $ErrorActionPreference = 'Stop'; `
    New-Item -ItemType Directory -Force -Path C:/temp, C:/steamcmd, C:/serverfiles | Out-Null; `
    Invoke-WebRequest -Uri $env:VC_REDIST_X86_URL -OutFile C:/temp/vc_redist.x86.exe -UseBasicParsing; `
    $vc86 = Start-Process C:/temp/vc_redist.x86.exe -ArgumentList '/install','/quiet','/norestart' -Wait -PassThru; `
    Write-Host ('Visual C++ x86 installer exit code: {0}' -f $vc86.ExitCode); `
    if ($vc86.ExitCode -notin 0, 1638, 3010) { throw ('Visual C++ x86 installation failed with exit code {0}' -f $vc86.ExitCode) }; `
    Invoke-WebRequest -Uri $env:VC_REDIST_X64_URL -OutFile C:/temp/vc_redist.x64.exe -UseBasicParsing; `
    $vc64 = Start-Process C:/temp/vc_redist.x64.exe -ArgumentList '/install','/quiet','/norestart' -Wait -PassThru; `
    Write-Host ('Visual C++ x64 installer exit code: {0}' -f $vc64.ExitCode); `
    if ($vc64.ExitCode -notin 0, 1638, 3010) { throw ('Visual C++ x64 installation failed with exit code {0}' -f $vc64.ExitCode) }; `
    Invoke-WebRequest -Uri $env:STEAMCMD_URL -OutFile C:/temp/steamcmd.zip -UseBasicParsing; `
    Expand-Archive -LiteralPath C:/temp/steamcmd.zip -DestinationPath C:/steamcmd -Force; `
    & C:/steamcmd/steamcmd.exe +quit; `
    $steamExitCode = $LASTEXITCODE; `
    if ($steamExitCode -eq 7) { `
        Write-Host 'SteamCMD returned exit code 7 after self-update; retrying bootstrap once.'; `
        Start-Sleep -Seconds 5; `
        & C:/steamcmd/steamcmd.exe +quit; `
        $steamExitCode = $LASTEXITCODE `
    }; `
    if ($steamExitCode -ne 0) { throw ('SteamCMD bootstrap failed with exit code {0}' -f $steamExitCode) }; `
    Remove-Item C:/temp -Recurse -Force

COPY Start.ps1 C:/tf2/Start.ps1

RUN $parseErrors = $null; `
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw -LiteralPath C:/tf2/Start.ps1), [ref]$parseErrors); `
    if ($parseErrors) { throw ($parseErrors | Out-String) }

EXPOSE 27015/udp
EXPOSE 27015/tcp

ENV TF2_ROOT=C:/serverfiles
ENV STEAMCMD_PATH=C:/steamcmd/steamcmd.exe

ENTRYPOINT ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "C:/tf2/Start.ps1"]
