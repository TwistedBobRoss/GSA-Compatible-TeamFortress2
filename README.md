# Team Fortress 2 for GameServerApp on Windows

Ready-to-use Windows container and GameServerApp blueprint for hosting Team Fortress 2 dedicated servers.

Team Fortress 2 is Valve's class-based Source multiplayer shooter with Payload, Payload Race, Control Point, King of the Hill, Capture the Flag, Mann vs Machine, and several other community-friendly modes. This project packages the TF2 dedicated server SteamCMD install flow, persistent configuration, logs, map rotation, and GameServerApp controls into a Windows Server 2022 container.

## Project Information

- Container and blueprint author: **TwistedBobRoss**
- Game developer: **Valve**
- Project type: unofficial community hosting integration
- Host operating system: Windows Server 2022 with Windows containers
- Steam dedicated server app: `232250`
- Steam Game Server Login Token app: `440`
- Primary image: `ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r4`
- Raw blueprint: `https://raw.githubusercontent.com/TwistedBobRoss/GSA-Compatible-TeamFortress2/main/blueprints/teamfortress2-custom-docker-windows.json`
- Repository: `https://github.com/TwistedBobRoss/GSA-Compatible-TeamFortress2`

Team Fortress 2 remains the property of Valve. This repository does not claim ownership of the game or its assets.

## What This Provides

- Prebuilt Windows Server 2022 container
- GameServerApp custom Docker blueprint
- SteamCMD install/update flow for TF2 Dedicated Server app `232250`
- Persistent server files mounted at `\serverfiles`
- Editable `server.cfg`, `mapcycle.txt`, `motd.txt`, and `motd_text.txt`
- Public Steam server-browser listing support with a TF2 GSLT
- Automatic GSA game-port assignment
- Source RCON password wiring through GSA
- Config controls for map, slots, LAN mode, bots, voting, team balance, downloads, and match flow
- Startup wrapper with SteamCMD retries and SRCDS launch logging
- GSA log directory registration for TF2 logs
- Custom content directory for plugins, custom maps, and other server-side files

## Requirements

- Windows Server 2022 or another host compatible with LTSC 2022 Windows containers
- GameServerApp DediConnect installed and connected
- Docker configured to run Windows containers
- Enough disk space for Windows container layers and TF2 server files
- Public UDP game port when hosting an internet server
- A Steam Game Server Login Token for public listing, created for App ID `440`

The first install can take several minutes because SteamCMD downloads TF2 server files into the persistent `serverfiles` mount.

## GameServerApp Installation

Download the published blueprint from the GameServerApp Marketplace when available. For manual import or review, use:

```text
https://raw.githubusercontent.com/TwistedBobRoss/GSA-Compatible-TeamFortress2/main/blueprints/teamfortress2-custom-docker-windows.json
```

Create a server from the blueprint, choose the slot limit, review the settings, and install it. The blueprint uses GSA automatic ports and passes the selected game port into SRCDS.

Use the GameServerApp `Import Custom Docker container` path if importing manually.

### Recommended First Test

```text
Starting Map = pl_upward
Steam Game Server Login Token = your TF2 GSLT for App ID 440
LAN Mode = Off / 0
Join Password = blank
Server Browser Tags = community,vanilla
Update On Start = On / 1
Validate On Update = Off / 0
Extra Launch Arguments = blank
Slot limit = 24
```

After the first successful install, you can set `Update On Start` to `0` for faster normal restarts. Turn it back on when you want SteamCMD to check for updates.

## Updating An Existing Server

Changing only an editable config file normally requires a server restart:

```text
\serverfiles\tf\cfg\server.cfg
\serverfiles\tf\cfg\mapcycle.txt
\serverfiles\tf\cfg\motd.txt
\serverfiles\tf\cfg\motd_text.txt
```

Changing the image tag, Docker environment variables, mounts, or blueprint directory types requires GSA to recreate or reinstall the container. The persistent mount must remain:

```text
\serverfiles
```

Do not wipe `serverfiles` unless you intentionally want to remove the installed TF2 server files, config files, custom content, maps, plugins, and logs.

### Restart, Recreate, Or Reinstall

Use a normal restart for:

```text
server.cfg edits
mapcycle.txt edits
MOTD edits
Most TF2 cvar changes
```

Recreate the container for Docker environment changes if a normal restart does not apply them:

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

Reinstall when changing blueprint image tags, repairing a broken SteamCMD install, or intentionally starting from clean server files.

## Public Server Listing

To appear in the TF2 server browser:

- Create a Steam Game Server Login Token for Team Fortress 2 App ID `440`.
- Paste the token into `Steam Game Server Login Token`.
- Use one unique token per running public server.
- Keep `LAN Mode` set to Off / `0`.
- Leave `Join Password` blank while testing public listing.
- Use a stock starting map such as `pl_upward`.
- Confirm the GSA-assigned UDP game port is reachable from the internet.
- Wait a few minutes after startup for Steam master-server listing.

Direct connect is the fastest test:

```text
connect <ip>:<port>
```

If direct connect works but the server browser does not show the server yet, focus on the GSLT, LAN mode, firewall/NAT, and Steam listing delay.

## Container Image

Primary image:

```text
ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r4
```

The `latest` tag may also exist, but the pinned image tag is recommended for GameServerApp blueprints.

This image contains SteamCMD and the startup wrapper. TF2 server files and maps are installed by SteamCMD into the persistent `serverfiles` mount during server installation/startup.

## Persistent Storage

The blueprint mounts:

```text
Host:      {container.home_root}/serverfiles
Container: C:\serverfiles
```

Important paths:

```text
C:\serverfiles                         TF2 dedicated server root
C:\serverfiles\srcds.exe               Source dedicated server executable
C:\serverfiles\tf\cfg                  Editable TF2 config files
C:\serverfiles\tf\cfg\server.cfg       Main server configuration
C:\serverfiles\tf\cfg\mapcycle.txt     Map rotation
C:\serverfiles\tf\cfg\motd.txt         HTML message of the day
C:\serverfiles\tf\cfg\motd_text.txt    Plain-text message of the day
C:\serverfiles\tf\maps                 Installed stock and custom maps
C:\serverfiles\tf\custom               Custom content
C:\serverfiles\tf\logs                 TF2 log files
C:\serverfiles\tf\console.log          SRCDS console log when `-condebug` is enabled
```

The GSA file manager shows these under:

```text
\serverfiles
```

## Ports

GSA assigns the game port automatically from this blueprint port type:

| Purpose | Protocol | Container default | GSA variable |
| --- | --- | ---: | --- |
| Game and server browser | UDP | `27015` | `{gameserver.game_port}` |
| Source RCON | TCP | `27015` | `{gameserver.game_port}` |

TF2 primarily needs the UDP game port for players and server-browser traffic. RCON uses TCP on the same port when exposed by the host.

## Included Maps

SteamCMD installs the standard TF2 Dedicated Server map files into:

```text
\serverfiles\tf\maps
```

Use map names without `.bsp` in `Starting Map` and `mapcycle.txt`.

Example:

```text
pl_upward.bsp -> pl_upward
```

The exact authoritative list on a live server is whatever `.bsp` files exist in `\serverfiles\tf\maps`.

### Payload

```text
pl_badwater
pl_barnblitz
pl_borneo
pl_cashworks
pl_enclosure_final
pl_frontier_final
pl_goldrush
pl_hoodoo_final
pl_phoenix
pl_pier
pl_rumford_event
pl_swiftwater_final1
pl_thundermountain
pl_upward
```

### Payload Race

```text
plr_bananabay
plr_hacksaw
plr_hightower
plr_nightfall_final
plr_pipeline
```

### Control Point

```text
cp_5gorge
cp_badlands
cp_coldfront
cp_degrootkeep
cp_dustbowl
cp_egypt_final
cp_fastlane
cp_foundry
cp_freight_final1
cp_gorge
cp_granary
cp_gravelpit
cp_junction_final
cp_metalworks
cp_mossrock
cp_powerhouse
cp_process_final
cp_snakewater_final1
cp_standin_final
cp_steel
cp_sunshine
cp_vanguard
cp_well
cp_yukon_final
```

### King Of The Hill

```text
koth_badlands
koth_bagel_event
koth_brazil
koth_cascade
koth_harvest_final
koth_highpass
koth_king
koth_lakeside_final
koth_lazarus
koth_maple_ridge_event
koth_megaton
koth_nucleus
koth_probed
koth_sawmill
koth_slasher
koth_suijin
koth_viaduct
```

### Capture The Flag

```text
ctf_2fort
ctf_doublecross
ctf_foundry
ctf_gorge
ctf_landfall
ctf_sawmill
ctf_thundermountain
ctf_turbine
ctf_well
```

### Arena

```text
arena_badlands
arena_byre
arena_granary
arena_lumberyard
arena_nucleus
arena_offblast_final
arena_ravine
arena_sawmill
arena_watchtower
arena_well
```

### Mann Vs Machine

```text
mvm_bigrock
mvm_coaltown
mvm_decoy
mvm_ghost_town
mvm_mannhattan
mvm_mannworks
mvm_rottenburg
```

### PASS Time

```text
pass_brickyard
pass_district
pass_timbertown
```

### Mixed Payload And Payload Race Rotation

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

## Custom Maps And Content

Upload custom maps to:

```text
\serverfiles\tf\maps
```

Upload custom content to:

```text
\serverfiles\tf\custom
```

Clients need a way to download custom maps and required content. For public custom-map servers, configure `FastDL URL` or keep the server rotation to stock maps.

## GameServerApp Parameter Reference

### Launch And Install

| Parameter | Default | Purpose |
| --- | --- | --- |
| Starting Map | `pl_upward` | Initial map loaded by SRCDS. Use the map name without `.bsp`. |
| Update On Start | `1` | Runs SteamCMD update before launch. Good for first install and update checks. |
| Validate On Update | `0` | Adds SteamCMD `validate`. Useful for repair, slower for normal restarts. |
| Extra Launch Arguments | blank | Raw SRCDS arguments appended after managed launch args. Leave blank while testing. |

### Identity And Access

| Parameter | Default | Purpose |
| --- | --- | --- |
| GSA server name | GSA list name | Written to `hostname` in `server.cfg`. |
| Steam Game Server Login Token | blank | Recommended for public listing. Create for App ID `440`. |
| LAN Mode | `0` | `0` for internet servers, `1` for LAN-only servers. |
| Join Password | blank | Sets `sv_password`; blank means public join access. |
| Server Browser Tags | `community,vanilla` | Comma-separated tags for browser filtering. |
| MOTD Message | welcome text | Written into the included MOTD templates. |
| RCON password | GSA RCON password | Written to `rcon_password` in `server.cfg`. |

### Content And Downloads

| Parameter | Default | Purpose |
| --- | --- | --- |
| Content Purity | `1` | Sets `sv_pure`. Standard mode is `1`; custom-heavy servers may need `0`. |
| Allow Client Downloads | `1` | Allows clients to download required server content. |
| Allow Client Uploads | `0` | Allows uploads from clients. Usually keep off. |
| FastDL URL | blank | Optional HTTP base URL for faster custom-map downloads. |

### Match Flow

| Parameter | Default | Purpose |
| --- | --- | --- |
| Map Time Limit | `30` | Minutes before the map time limit is reached. `0` disables. |
| Maximum Rounds | `0` | Completed-round limit before changing map. `0` disables. |
| Win Limit | `0` | Changes map when a team reaches this many wins. `0` disables. |
| End At Time Limit | `0` | Ends the map as soon as the time limit is reached. |
| Instant Respawns | `0` | Disables normal TF2 respawn wave delays when enabled. |

### Teams

| Parameter | Default | Purpose |
| --- | --- | --- |
| Automatic Team Balance | `1` | Allows TF2 to balance uneven teams. |
| Team Imbalance Limit | `1` | Player-count difference before balancing can intervene. |
| Automatic Team Scramble | `0` | Enables automatic team scrambling. |

### Voice And Gameplay

| Parameter | Default | Purpose |
| --- | --- | --- |
| All Talk | `0` | Allows voice chat across teams when enabled. |
| Random Critical Hits | `1` | Enables normal TF2 random critical hits. |
| Random Melee Critical Hits | Follow global | Controls melee random critical behavior. |

### Bots

| Parameter | Default | Purpose |
| --- | --- | --- |
| TF Bot Quota | `0` | Number of managed TF bots. |
| TF Bot Quota Mode | `fill` | `normal`, `fill`, or `match` bot population behavior. |
| TF Bot Difficulty | `1` | Bot difficulty: `0` easy, `1` normal, `2` hard, `3` expert. |
| Bots Wait For Human | `1` | Bots wait until a human joins. |
| Bots Yield Slots | `1` | Bots leave to make room for human players. |

### Voting

| Parameter | Default | Purpose |
| --- | --- | --- |
| Allow Kick Votes | `1` | Allows player-initiated kick votes. |
| Allow Change-Map Votes | `1` | Allows votes to change the current map. |
| Allow Next-Map Votes | `1` | Allows votes for the next map. |
| Allow Team-Scramble Votes | `1` | Allows votes to scramble teams. |

### Performance

| Parameter | Default | Purpose |
| --- | --- | --- |
| Hibernate While Empty | `1` | Allows the server to reduce activity while empty. |

## Editable Configuration Files

The GSA configuration template exposes:

```text
\serverfiles\tf\cfg\server.cfg
\serverfiles\tf\cfg\mapcycle.txt
\serverfiles\tf\cfg\motd.txt
\serverfiles\tf\cfg\motd_text.txt
```

Values controlled by GSA parameters are written into these files by the config template. If you manually edit a line that is still controlled by a GSA parameter, the template may overwrite it later.

## Container Environment Variables

GSA supplies these automatically:

```text
TF2_PORT
TF2_MAXPLAYERS
TF2_START_MAP
TF2_STEAM_GSLT
TF2_SV_LAN
TF2_PUBLIC_IP
TF2_UPDATE_ON_START
TF2_VALIDATE_ON_UPDATE
TF2_EXTRA_ARGS
```

Internal/maintainer variables:

```text
STEAMCMD_PATH
TF2_ROOT
```

## Direct Docker Example

```powershell
docker run -d --name tf2-gsa-test `
  -p 27015:27015/udp `
  -p 27015:27015/tcp `
  -v C:\tf2-test\serverfiles:C:\serverfiles `
  -e TF2_PORT="27015" `
  -e TF2_MAXPLAYERS="24" `
  -e TF2_START_MAP="pl_upward" `
  -e TF2_STEAM_GSLT="" `
  -e TF2_SV_LAN="0" `
  -e TF2_UPDATE_ON_START="1" `
  -e TF2_VALIDATE_ON_UPDATE="0" `
  ghcr.io/twistedbobross/gsa-compatible-teamfortress2:232250-ltsc2022-r4
```

## Troubleshooting

### First Install Takes A Long Time

- SteamCMD downloads TF2 server files into `\serverfiles`.
- Leave the installation running while SteamCMD completes app `232250`.
- Confirm the host has enough disk space for Docker layers and TF2 server files.
- Later starts are faster when `Update On Start` is off.

### Server Exits Immediately

- Check the Docker container log.
- Check `\serverfiles\tf\console.log`.
- Check `\serverfiles\tf\logs`.
- Confirm `srcds.exe` exists under `\serverfiles`.
- Confirm the selected starting map exists under `\serverfiles\tf\maps`.

### GSA Mentions `gsa-control.ps1`

The server is using an old GSA + Steam/custom-launch attempt. Switch to the custom Docker blueprint:

```text
blueprints/teamfortress2-custom-docker-windows.json
```

Then recreate or reinstall the server so the correct container image and launch flow are used.

### Server Is Not In The Public List

- Confirm the GSLT was created for App ID `440`.
- Confirm `LAN Mode` is `0`.
- Leave `Join Password` blank while testing.
- Confirm the UDP game port is reachable.
- Use direct connect to verify the server itself is reachable.
- Wait a few minutes for Steam's browser listing.

### Config Changes Do Not Stick

- Edit the GSA-exposed files under `\serverfiles\tf\cfg`.
- Restart after file edits.
- Recreate the container after changing Docker environment values.
- Do not wipe `serverfiles` during routine config updates.

### Players Cannot Download Custom Maps

- Confirm the `.bsp` exists under `\serverfiles\tf\maps`.
- Set `Allow Client Downloads` to `1`.
- Configure `FastDL URL` for public custom-map servers.
- Keep `sv_pure` compatible with the custom content you expect clients to use.

## Repository Files

```text
blueprints/teamfortress2-custom-docker-windows.json  GameServerApp blueprint
Dockerfile                                           Windows image definition
Start.ps1                                           SteamCMD and SRCDS startup wrapper
docker-run.gsa-import.txt                           GSA Docker import seed
docs/                                               Supporting operator notes
.github/workflows/build-ghcr.yml                    Container build workflow
```

Normal server owners do not need to build the image. Use the published blueprint and pinned GHCR image.

## Sources And Credits

- [Valve Team Fortress 2](https://www.teamfortress.com/)
- [Team Fortress Wiki dedicated server documentation](https://wiki.teamfortress.com/wiki/Windows_dedicated_server)
- [Steam Game Server Account Management](https://steamcommunity.com/dev/managegameservers)
- [GameServerApp blueprint documentation](https://docs.gameserverapp.com/dashboard/blueprints/create_and_manage_blueprints/)

Team Fortress 2 is created by Valve. This GameServerApp integration, container wrapper, documentation, and automated build workflow are maintained by TwistedBobRoss.
