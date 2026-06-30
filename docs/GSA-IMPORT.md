# GameServerApp Import Guide

Use the recommended GameServerApp `Import Custom Docker container` path:

```text
blueprints/teamfortress2-custom-docker-windows.json
```

The custom image is:

```text
ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r4
```

The image installs or updates Team Fortress 2 Dedicated Server app `232250` with SteamCMD, then launches `srcds.exe` from `C:/serverfiles`.

You can also seed the GSA Docker importer with:

```text
docker-run.gsa-import.txt
```

After GitHub Actions publishes the image, confirm the GHCR package visibility is public. A private GHCR package will cause image pull failures on GSA hosts unless registry credentials are configured.

## Required Or Recommended Values

| Parameter | Recommended value | Notes |
| --- | --- | --- |
| `start_map` | `pl_upward` | Use a valid TF2 map name without `.bsp`. |
| `steam_gslt` | Your TF2 GSLT | Recommended for public listing. Create the token for App ID `440`. |
| `sv_lan` | `0` | Keep off for an internet-accessible server. |
| `server_password` | Blank | Leave blank for public listing tests. |
| `update_on_start` | `1` first install, then optional `0` | Set to `0` later for faster restarts. |
| `validate_on_update` | `0` | Use `1` only for repair attempts. |
| `extra_args` | Blank | Add raw SRCDS args only after the server works normally. |

## GSA Directories

The blueprint registers:

| Name | Path | Type |
| --- | --- | --- |
| Serverfiles | `\serverfiles` | `normal` |
| TF2 Config | `\serverfiles\tf\cfg` | `normal` |
| TF2 Logs | `\serverfiles\tf\logs` | `logs` |
| TF2 Custom Content | `\serverfiles\tf\custom` | `normal` |

## First Boot

The first start can take several minutes while SteamCMD prepares the Team Fortress 2 Dedicated Server files under `C:/serverfiles`. The startup script retries SteamCMD because the app update can report success before `srcds.exe` is present, especially around SteamCMD self-updates.

Recommended first checks:

1. Confirm the GitHub Actions image build published the pinned image tag.
2. Confirm the GHCR package is public.
3. Watch the Docker container log for app `232250` install/update progress.
4. Confirm `srcds.exe` exists under `\serverfiles`.
5. Confirm `server.cfg`, `mapcycle.txt`, `motd.txt`, and `motd_text.txt` exist under `\serverfiles\tf\cfg`.
6. Confirm the server reaches the configured starting map.

## Startup Command

The image launches SRCDS with managed arguments equivalent to:

```text
-game tf -console -norestart -usercon -strictportbind -condebug -ip 0.0.0.0 -port {gameserver.game_port} +sv_lan {config_parameter id="sv_lan"} +maxplayers {gameserver.slot_limit} +exec server.cfg +net_public_adr {machine.ip} +sv_setsteamaccount {config_parameter id="steam_gslt"} +map {config_parameter id="start_map"} +heartbeat
```

`+net_public_adr` and `+sv_setsteamaccount` are only added when their values are usable.

## Online Visibility

For public listing:

- Use a valid TF2 Steam Game Server Login Token for App ID `440`.
- Use one unique token per concurrently running server.
- Keep `sv_lan` set to `0`.
- Leave the join password blank while testing.
- Use a stock starting map while testing.
- Confirm the machine's assigned UDP game port is reachable from the internet.

The server may take a few minutes to appear in the Steam server browser. Direct connect is the fastest test:

```text
connect <ip>:<port>
```
