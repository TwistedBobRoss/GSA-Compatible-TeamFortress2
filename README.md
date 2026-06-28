# GSA-Compatible Team Fortress 2

GameServerApp GSA + Steam blueprint for Team Fortress 2 Dedicated Server using the GameServerApp DediConnect Windows image.

## Blueprint

Import:

```text
blueprints/teamfortress2-gsa-dediconnect-windows.json
```

The blueprint is intended for the `GSA + Steam (Windows only)` template. It uses Steam client app `440` and dedicated server app `232250` with the official GSA DediConnect Windows image, then launches `srcds.exe` with GSA-managed ports, slots, map, and configuration files.

## What Was Fixed

- Added `_version: 3` and `type: custom` at the root so the file matches the other GSA custom import packages.
- Normalized the Docker mount source to `{container.home_root}/serverfiles` and the container target to `C:/Users/ContainerUser/serverfiles`.
- Set the official GSA container user to `containeruser`, matching GameServerApp's blueprint guidance.
- Restored the `gsa-control.ps1` file expected by the DediConnect Windows launch flow.
- The control script uses the Steam install tool already present in the official image and avoids external downloads.
- Avoided embedding direct Steam install/update command strings in the import JSON, which caused Cloudflare/GSA submission blocks.
- Added defaults for dropdown-backed parameters that previously rendered blank TF2 cvars.
- Added `-strictportbind` and `-condebug` to make port binding and startup logs easier to diagnose.

## First Boot Checklist

1. Create or update the blueprint using `GSA + Steam (Windows only)`, not `Import Custom Docker container`.
2. Set `Starting Map` to a stock map such as `pl_upward`.
3. For a public server, set a TF2 Steam Game Server Login Token for App ID `440`.
4. Keep `Update Server On Start` enabled for the first boot.
5. Install/reinstall the server and let the startup script prepare app `232250`.
6. After startup, check `\serverfiles\tf\logs` and `\serverfiles\tf\console.log`.

## GameServerApp References

This blueprint was checked against GameServerApp's official GitHub documentation for GSA + Steam blueprints, official DediConnect Docker images, blueprint variables, Windows container paths, and custom launch scripts.

## Repository Layout

```text
blueprints/
  teamfortress2-gsa-dediconnect-windows.json
docs/
  GSA-IMPORT.md
  TROUBLESHOOTING.md
```
