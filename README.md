# GSA-Compatible Team Fortress 2

GameServerApp custom Windows container and blueprint for Team Fortress 2 Dedicated Server.

## Blueprint

Recommended import:

```text
blueprints/teamfortress2-custom-docker-windows.json
```

The recommended blueprint uses a custom GHCR image:

```text
ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r3
```

The image installs/updates Steam app `232250` with SteamCMD inside the container, using an official-style TF2 SteamCMD script and multiple install passes if needed, then launches `srcds.exe` with GSA-managed ports, slots, map, and configuration files.

After the first GitHub Actions build, confirm the GHCR package visibility is public. If the package is private, GSA will not be able to pull it without registry credentials.

The earlier `GSA + Steam` blueprint is still kept at:

```text
blueprints/teamfortress2-gsa-dediconnect-windows.json
```

That version exposed a GSA launch-flow issue where the server kept trying to run `gsa-control.ps1`. The custom Docker image is now the preferred path, matching the approach used by the working Renegade X and SuperTuxKart blueprints.

## What Was Fixed

- Added a custom Windows Docker image build that installs SteamCMD and launches TF2 from `C:/serverfiles`.
- Added a GHCR publishing workflow for `ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r3`.
- Added `blueprints/teamfortress2-custom-docker-windows.json` for the custom Docker import path.
- Kept install/start logic out of the GSA JSON so the dashboard only receives Docker metadata, environment variables, and config templates.
- Added defaults for dropdown-backed parameters that previously rendered blank TF2 cvars.
- Added `-strictportbind` and `-condebug` to make port binding and startup logs easier to diagnose.

## First Boot Checklist

1. Let the GitHub Actions workflow build and publish the `232250-ltsc2022-r3` GHCR image.
2. Create or update the blueprint using `Import Custom Docker container`.
3. Import `blueprints/teamfortress2-custom-docker-windows.json` or seed from `docker-run.gsa-import.txt`.
4. Set `Starting Map` to a stock map such as `pl_upward`.
5. For a public server, set a TF2 Steam Game Server Login Token for App ID `440`.
6. Install/reinstall the server and let the custom image prepare app `232250`.
7. After startup, check `\serverfiles\tf\logs` and `\serverfiles\tf\console.log`.

## GameServerApp References

This blueprint was checked against GameServerApp's official GitHub documentation for GSA + Steam blueprints, official DediConnect Docker images, blueprint variables, Windows container paths, and custom launch scripts.

## Repository Layout

```text
blueprints/
  teamfortress2-custom-docker-windows.json
  teamfortress2-gsa-dediconnect-windows.json
.github/workflows/
  build-ghcr.yml
Dockerfile
Start.ps1
docker-run.gsa-import.txt
docs/
  GSA-IMPORT.md
  TROUBLESHOOTING.md
```
