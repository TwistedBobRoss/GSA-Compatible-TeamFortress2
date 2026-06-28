# GSA-Compatible Team Fortress 2

GameServerApp custom blueprint for Team Fortress 2 Dedicated Server using the GameServerApp DediConnect Windows image.

## Blueprint

Import:

```text
blueprints/teamfortress2-gsa-dediconnect-windows.json
```

The blueprint uses Steam client app `440` and dedicated server app `232250`, installs into the DediConnect server files directory, and launches `srcds.exe` with GSA-managed ports, slots, map, and configuration files.

## What Was Fixed

- Added `_version: 3` and `type: custom` at the root so the file matches the other GSA custom import packages.
- Normalized the Docker mount source to `{container.home_root}/serverfiles` and the container target to `C:/Users/ContainerUser/serverfiles`.
- Moved `sv_setsteamaccount` out of `server.cfg` and into `launch_parameters`, so the token is available while SRCDS is starting.
- Added defaults for dropdown-backed parameters that previously rendered blank TF2 cvars.
- Added `-strictportbind` and `-condebug` to make port binding and startup logs easier to diagnose.

## First Boot Checklist

1. Import the blueprint into GameServerApp.
2. Set `Starting Map` to a stock map such as `pl_upward`.
3. For a public server, set a TF2 Steam Game Server Login Token for App ID `440`.
4. Start the server and watch the Docker container log while SteamCMD installs app `232250`.
5. After startup, check `\serverfiles\tf\logs` and `\serverfiles\tf\console.log`.

## Repository Layout

```text
blueprints/
  teamfortress2-gsa-dediconnect-windows.json
docs/
  GSA-IMPORT.md
  TROUBLESHOOTING.md
```
