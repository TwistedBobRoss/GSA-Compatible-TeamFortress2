# Team Fortress 2 - Windows GSA Blueprint

Host a Team Fortress 2 dedicated server on GameServerApp with a ready-to-use Windows container blueprint.

This blueprint installs the official TF2 Dedicated Server app through SteamCMD, keeps server files persistent, exposes editable GSA config templates, and launches SRCDS with GameServerApp-managed ports, slots, map selection, logs, and public-listing settings.

## Highlights

- Windows Server 2022 container image
- SteamCMD install/update for TF2 Dedicated Server app `232250`
- Editable `server.cfg`, `mapcycle.txt`, `motd.txt`, and `motd_text.txt`
- Public server-browser support with a TF2 GSLT for App ID `440`
- Config controls for map, password, tags, LAN mode, bots, votes, downloads, match flow, and team balance
- Persistent `\serverfiles` storage for configs, logs, maps, plugins, and custom content
- Vanilla-focused defaults with a recommended 24-slot setup

## Recommended First Setup

```text
Starting Map = pl_upward
Slot Limit = 24
LAN Mode = Off
Join Password = blank
Update On Start = On for first install
Validate On Update = Off
Extra Launch Arguments = blank
```

For public listing, create a Steam Game Server Login Token for Team Fortress 2 App ID `440`, paste it into the GSLT field, and keep LAN Mode off. Use one unique GSLT per running TF2 server; reusing the same token on multiple live servers can stop one or more servers from appearing in the public browser.

## Vanilla Slot Guidance

This blueprint is marketed as a vanilla TF2 server blueprint.

```text
Recommended slots: 24
Intended vanilla maximum: 32
```

Higher slot counts require custom launch arguments and owner tuning. They are not the intended default behavior for this vanilla blueprint.

## Notes

Normal config edits such as `server.cfg`, `mapcycle.txt`, and MOTD changes should only require a restart. Docker image, mount, port, or environment-variable changes may require the container to be recreated or the server to be reinstalled.

Team Fortress 2 is created by Valve. This is an unofficial community GameServerApp integration maintained by TwistedBobRoss.
