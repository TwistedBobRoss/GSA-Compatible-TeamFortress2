# GSA-Compatible Team Fortress 2

Ready-to-use Windows container image and GameServerApp blueprint for hosting a Team Fortress 2 dedicated server.

This project uses a custom GHCR Windows container because the normal GSA + Steam Windows flow was trying to launch `gsa-control.ps1` from the server file mount before the script existed. The container keeps the install/start logic in `Start.ps1`, while the GSA blueprint only handles Docker metadata, ports, environment variables, and editable config templates.

## Container Image

Use the pinned image tag for predictable installs:

```text
ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r4
```

The `latest` tag may also exist, but the pinned tag is recommended for GameServerApp blueprints.

This image is intended for Windows container hosts, such as Windows Server 2022 with Docker configured for Windows containers. It is not a Linux container image.

## What This Provides

- Prebuilt Windows container image for Team Fortress 2 Dedicated Server app `232250`
- GameServerApp custom Docker blueprint JSON
- SteamCMD install/update flow inside the container
- Editable `server.cfg`, `mapcycle.txt`, `motd.txt`, and `motd_text.txt`
- Public server listing support through a TF2 Steam Game Server Login Token
- GSA config parameters wired into Docker environment variables
- Startup wrapper with SteamCMD retries and SRCDS launch logging
- Registered GSA directories for config, logs, custom content, and server files

## GameServerApp Setup

Import this blueprint using GameServerApp's `Import Custom Docker container` path:

```text
blueprints/teamfortress2-custom-docker-windows.json
```

You can also seed the Docker importer with:

```text
docker-run.gsa-import.txt
```

Recommended first public setup:

```text
Starting Map = pl_upward
Steam Game Server Login Token = your TF2 GSLT for App ID 440
LAN Mode = 0
Join Password = blank
Update On Start = 1 for first install
Validate On Update = 0
Extra Launch Arguments = blank
```

After the server is installed and running normally, `Update On Start` can be set to `0` to make ordinary restarts faster.

## Docker Environment Variables

The blueprint should create these automatically:

```text
TF2_PORT = {gameserver.game_port}
TF2_MAXPLAYERS = {gameserver.slot_limit}
TF2_START_MAP = {config_parameter id="start_map"}
TF2_STEAM_GSLT = {config_parameter id="steam_gslt"}
TF2_SV_LAN = {config_parameter id="sv_lan"}
TF2_PUBLIC_IP = {machine.ip}
TF2_UPDATE_ON_START = {config_parameter id="update_on_start"}
TF2_VALIDATE_ON_UPDATE = {config_parameter id="validate_on_update"}
TF2_EXTRA_ARGS = {config_parameter id="extra_args"}
```

Do not publish a public blueprint containing a real GSLT.

## Ports

```text
27015/UDP = TF2 game traffic and Steam server browser
27015/TCP = Source RCON, when exposed by the host
```

The blueprint enables GSA automatic ports and maps the game port through `{gameserver.game_port}`.

## Configuration Files

The editable GSA config files are:

```text
\serverfiles\tf\cfg\server.cfg
\serverfiles\tf\cfg\mapcycle.txt
\serverfiles\tf\cfg\motd.txt
\serverfiles\tf\cfg\motd_text.txt
```

Inside the container, the server files are mounted at:

```text
C:/serverfiles
```

The TF2 maps installed by SteamCMD are under:

```text
\serverfiles\tf\maps
```

Use map names without `.bsp` in `mapcycle.txt` and in the `Starting Map` setting.

## Restart, Recreate, Or Reinstall

Most config file edits only need a server restart:

```text
server.cfg
mapcycle.txt
motd.txt
motd_text.txt
```

Docker environment variable changes may require the container to be recreated so the new values are injected:

```text
Starting Map
Steam Game Server Login Token
LAN Mode
Update On Start
Validate On Update
Extra Launch Arguments
Slot limit
Game port
```

A full reinstall is mainly for clean server files, blueprint/image changes, or broken partial installs. Do not delete the `serverfiles` mount unless you intentionally want to wipe the installed TF2 server.

See `docs/CONFIG-CHANGES.md` for the detailed rule of thumb.

## Map Rotations

For a Payload + Payload Race rotation, use:

```text
pl_upward
plr_hightower
pl_badwater
plr_pipeline
pl_barnblitz
plr_nightfall_final
pl_swiftwater_final1
plr_bananabay
pl_borneo
pl_goldrush
plr_hacksaw
pl_frontier_final
pl_thundermountain
pl_hoodoo_final
pl_enclosure_final
pl_pier
```

More map groups and rotation notes are in `docs/MAPS.md`.

## Public Listing Checklist

- Use a valid Team Fortress 2 GSLT for App ID `440`.
- Use one unique GSLT per running public server.
- Keep `LAN Mode` set to `0`.
- Leave `Join Password` blank while testing public listing.
- Use a known stock starting map such as `pl_upward`.
- Confirm the assigned UDP game port is reachable from the internet.
- Wait a few minutes after boot for Steam master-server listing to catch up.

## Repository Files

- `blueprints/teamfortress2-custom-docker-windows.json` - import this into GameServerApp.
- `docker-run.gsa-import.txt` - simple Docker import seed command for GSA.
- `Dockerfile` - maintainer build definition for the published image.
- `Start.ps1` - container startup wrapper.
- `docs/GSA-IMPORT.md` - GSA import and first boot guide.
- `docs/CONFIG-CHANGES.md` - restart, recreate, and reinstall behavior.
- `docs/MAPS.md` - stock map groups and rotation examples.
- `docs/TROUBLESHOOTING.md` - common startup and visibility problems.

## Maintainer Notes

Normal users do not need to build this image. The published GHCR image is intended to be consumed directly by GameServerApp or Docker.

If you maintain the image yourself, use the included GitHub Actions workflow to publish a new pinned tag to GitHub Container Registry, then update the blueprint image tag.
