# GameServerApp Import Guide

Use this file with the recommended GameServerApp `Import Custom Docker container` path:

```text
blueprints/teamfortress2-custom-docker-windows.json
```

The custom image is:

```text
ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r2
```

The image applies the required Team Fortress 2 SteamCMD setting before installing app `232250`:

```text
app_set_config 232250 mod tf
```

You can also seed the GSA Docker importer with:

```text
docker-run.gsa-import.txt
```

After the GitHub Actions build finishes, confirm the GHCR package is public. A private GHCR package will cause image pull failures on GSA hosts unless registry credentials are configured.

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

The first start can take several minutes while the custom image prepares the Team Fortress 2 Dedicated Server files under `C:/serverfiles`.

Recommended first checks:

1. Confirm the GitHub Actions image build published the `232250-ltsc2022-r2` tag successfully.
2. Confirm the GHCR package is public.
3. Watch the Docker container log for Team Fortress 2 app `232250` install/update progress.
4. Confirm `srcds.exe` exists under `\serverfiles` after installation.
5. Confirm `server.cfg`, `mapcycle.txt`, `motd.txt`, and `motd_text.txt` exist under `\serverfiles\tf\cfg`.
6. Confirm the server reaches the configured start map instead of exiting immediately.

## Startup Command

The image installs/updates app `232250` and launches SRCDS with:

```text
-game tf -console -norestart -usercon -strictportbind -condebug -port {gameserver.game_port} +map {config_parameter id="start_map"} +maxplayers {gameserver.slot_limit} +exec server.cfg
```

The custom Docker blueprint intentionally keeps install/start logic out of the GSA JSON. The GSA JSON points at the GHCR image and passes environment variables into `Start.ps1`.
