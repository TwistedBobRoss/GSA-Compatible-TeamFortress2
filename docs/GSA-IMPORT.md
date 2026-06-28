# GameServerApp Import Guide

Use this file with a GameServerApp `GSA + Steam (Windows only)` blueprint version:

```text
blueprints/teamfortress2-gsa-dediconnect-windows.json
```

## Required Or Recommended Values

| Parameter | Recommended value | Notes |
| --- | --- | --- |
| `start_map` | `pl_upward` | Use a valid TF2 map name without `.bsp`. |
| `steam_gslt` | Your TF2 GSLT | Recommended for public listing. Create the token for App ID `440`. |
| `sv_lan` | `0` | Keep off for an internet-accessible server. |
| `server_password` | Blank | Leave blank for a public server. |

## GSA Directories

The blueprint registers:

| Name | Path | Type |
| --- | --- | --- |
| Server Root | `\serverfiles` | `normal` |
| TF2 Config | `\serverfiles\tf\cfg` | `normal` |
| TF2 Logs | `\serverfiles\tf\logs` | `logs` |
| TF2 Custom Content | `\serverfiles\tf\custom` | `normal` |

## First Boot

The first start can take several minutes while GSA + Steam prepares the Team Fortress 2 Dedicated Server files.

Recommended first checks:

1. Watch the Docker container log for GSA + Steam install progress.
2. Confirm `srcds.exe` exists under `\serverfiles` after installation.
3. Confirm `server.cfg`, `mapcycle.txt`, `motd.txt`, and `motd_text.txt` exist under `\serverfiles\tf\cfg`.
4. Confirm the server reaches the configured start map instead of exiting immediately.

## Startup Command

The blueprint launches SRCDS with:

```text
-game tf -console -norestart -usercon -strictportbind -condebug -port {gameserver.game_port} +map {config_parameter id="start_map"} +maxplayers {gameserver.slot_limit} +exec server.cfg
```

The blueprint intentionally does not include a custom `gsa-control.ps1` install script. GSA + Steam should generate/manage the Steam install and launch flow.
