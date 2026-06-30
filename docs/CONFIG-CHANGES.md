# Config Changes

This blueprint has two kinds of settings:

- File-based config templates written into `\serverfiles`.
- Docker environment variables injected when the container is created.

That distinction controls whether a restart, container recreate, or reinstall is needed.

## Restart Is Enough

These files are mounted in the persistent server files path:

```text
\serverfiles\tf\cfg\server.cfg
\serverfiles\tf\cfg\mapcycle.txt
\serverfiles\tf\cfg\motd.txt
\serverfiles\tf\cfg\motd_text.txt
```

For edits to these files, a normal server restart should be enough.

Examples:

```text
Changing mapcycle.txt
Changing MOTD text
Changing hostname in server.cfg
Changing TF2 cvars in server.cfg
Changing bot settings in server.cfg
```

Some `server.cfg` changes can also be applied while the server is running with:

```text
exec server.cfg
```

A restart is still the cleanest approach when testing.

## Recreate The Container

These values are passed to the Docker container as environment variables:

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

If GSA reuses the existing container, changing these settings may not take effect with a simple restart. Delete/recreate the container or reinstall/recreate the server so Docker receives the updated environment.

Common examples:

```text
Changing Starting Map
Changing Steam Game Server Login Token
Changing LAN Mode
Changing Extra Launch Arguments
Changing Update On Start
Changing Validate On Update
Changing slot limit
Changing game port
```

Do not delete the mounted `serverfiles` folder unless you intentionally want to wipe the installed TF2 server.

## Reinstall The Server

Use reinstall for clean server file state or blueprint-level changes.

Good reasons to reinstall:

```text
Changing the Docker image name or tag
Changing blueprint mounts or registered directories
Recovering from a partial or corrupted SteamCMD install
Starting over with clean TF2 server files
Applying a newly imported blueprint version to an existing broken server
```

Reinstalling may wipe or regenerate files depending on the GSA action selected, so back up custom config, maps, and plugins first.

## Map Changes

Changing the current running map does not require reinstall.

Immediate map switch through console or RCON:

```text
changelevel pl_upward
```

Rotation change:

```text
Edit \serverfiles\tf\cfg\mapcycle.txt
Restart the server
```

Startup map change:

```text
Change Starting Map in GSA
Restart first
If it still starts on the old map, recreate the container
```
