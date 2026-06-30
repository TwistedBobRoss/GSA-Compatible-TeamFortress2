# Troubleshooting

## Server Exits Immediately

Check the Docker container log first. Then check:

```text
\serverfiles\tf\console.log
\serverfiles\tf\logs
```

If the log says `C:\Users\ContainerUser\serverfiles\gsa-control.ps1` is not recognized, the server is still using the old GSA + Steam/custom-launch attempt. Switch to `blueprints/teamfortress2-custom-docker-windows.json`, create the version through `Import Custom Docker container`, clear any Config template special custom launch script, activate that template on the server, and recreate or reinstall.

If the log says `srcds.exe` cannot be found, SteamCMD did not finish installing app `232250` or the server files mount is wrong. The custom Docker blueprint mounts GSA storage at:

```text
{container.home_root}/serverfiles -> C:/serverfiles
```

## Image Pull Fails

Confirm the GHCR package is public:

```text
ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r4
```

If the package is private, GSA cannot pull it without registry credentials.

## Blueprint Import Blocked

If GameServerApp or Cloudflare blocks the blueprint import, make sure the GSA JSON does not contain large PowerShell install scripts. The recommended blueprint keeps install/update logic inside the Docker image and imports only Docker metadata, environment variables, ports, directories, and config templates.

Use:

```text
blueprints/teamfortress2-custom-docker-windows.json
```

## Invalid Or Missing Map

If the server exits after map or BSP errors, set `Starting Map` to a stock installed map such as:

```text
pl_upward
cp_dustbowl
koth_viaduct
ctf_2fort
```

Do not include `.bsp`.

The installed map files are under:

```text
\serverfiles\tf\maps
```

## Public Listing Problems

For public listing:

- Create a Steam Game Server Login Token for Team Fortress 2 App ID `440`.
- Paste it into `Steam Game Server Login Token`.
- Use one unique token per running public server.
- Keep `LAN Mode` set to `0`.
- Leave `Join Password` blank while testing.
- Confirm the assigned UDP game port is reachable.
- Wait a few minutes for Steam master-server listing.

If the server is joinable through direct connect but not visible in the browser yet, the server process is probably healthy and the issue is listing, token, firewall, or propagation delay.

## Config Changes Do Not Apply

File edits such as `server.cfg` and `mapcycle.txt` should only need a restart.

Docker environment values such as `Starting Map`, `Steam Game Server Login Token`, `LAN Mode`, and `Extra Launch Arguments` may require the container to be recreated so Docker receives the new environment.

See:

```text
docs/CONFIG-CHANGES.md
```

## Blank Cvars

Dropdown parameters must have default `content` values. If a GSA config parameter renders blank, the resulting TF2 cvar can look like:

```text
sv_pure ""
tf_bot_quota_mode ""
tf_bot_difficulty ""
```

Use the current blueprint, which supplies defaults for dropdown-backed values.

## RCON Notes

TF2 Source RCON uses the game port over TCP and the `rcon_password` from `server.cfg`. This blueprint writes:

```text
rcon_password "{gameserver.rcon_password}"
```

Use the same public port as the server game port when connecting with a Source RCON client unless your GSA/Docker host exposes a separate proxy port.
