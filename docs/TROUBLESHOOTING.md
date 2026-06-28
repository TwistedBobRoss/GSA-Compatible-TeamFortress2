# Troubleshooting

## Server Exits Immediately

Check the Docker container log first. Then check:

- `\serverfiles\tf\console.log`
- `\serverfiles\tf\logs`

If the log says `C:\Users\ContainerUser\serverfiles\gsa-control.ps1` is not recognized, the active GSA blueprint/config template did not write the control script. Import the latest blueprint version, activate it on the server's config template, then reinstall or restart after applying the template.

If the log says the Steam install tool cannot be found, the official DediConnect Windows image being used by that server does not expose the expected install tool paths. At that point a small custom image based on the official image may be worth considering.

If the log says `srcds.exe` cannot be found, the Steam app `232250` did not finish installing or the server files mount is wrong. This blueprint mounts GSA storage at:

```text
{container.home_root}/serverfiles -> C:/Users/ContainerUser/serverfiles
```

## Blueprint Import Blocked

If GameServerApp or Cloudflare blocks the blueprint import, make sure you are using the current blueprint from this repository. It does not embed direct Steam install/update command strings, web-download commands, archive extraction, or external installer URLs inside the submitted JSON.

## Invalid Or Missing Map

If the server exits after printing map or BSP errors, set `Starting Map` to a stock map such as:

```text
pl_upward
cp_dustbowl
koth_viaduct
ctf_2fort
```

Do not include `.bsp`.

## Public Listing Problems

For public listing, create a Steam Game Server Login Token for Team Fortress 2 App ID `440`, then paste it into `Steam Game Server Login Token`.

Use one unique token per concurrently running server. Reusing the same token on multiple live servers can cause Steam login or listing problems.

## Blank Cvars

The previous blueprint had dropdown parameters without `content` defaults. That can render blank cvars such as:

```text
sv_pure ""
tf_bot_quota_mode ""
tf_bot_difficulty ""
```

The corrected blueprint gives those parameters default values.

## RCON Notes

TF2 Source RCON uses the game port over TCP and the `rcon_password` from `server.cfg`. This blueprint maps the GSA game port and writes:

```text
rcon_password "{gameserver.rcon_password}"
```

Use the same public port as the server game port when connecting with a Source RCON client unless your GameServerApp/Docker host exposes a separate proxy port.
