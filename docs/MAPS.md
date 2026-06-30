# Maps And Rotations

SteamCMD installs Team Fortress 2 Dedicated Server app `232250` into:

```text
\serverfiles
```

The standard installed maps live here:

```text
\serverfiles\tf\maps
```

Use map names without `.bsp` in `mapcycle.txt` and in the `Starting Map` setting.

Example:

```text
pl_upward.bsp -> pl_upward
```

The authoritative list for a running server is always the `.bsp` files present in `\serverfiles\tf\maps`.

## Payload

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

## Payload Race

```text
plr_bananabay
plr_hacksaw
plr_hightower
plr_nightfall_final
plr_pipeline
```

## Payload + Payload Race Rotation

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

## Control Point

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

## King Of The Hill

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

## Capture The Flag

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

## Arena

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

## Mann Vs Machine

```text
mvm_bigrock
mvm_coaltown
mvm_decoy
mvm_ghost_town
mvm_mannhattan
mvm_mannworks
mvm_rottenburg
```

## PASS Time

```text
pass_brickyard
pass_district
pass_timbertown
```

## Notes

Payload-only servers only need Payload maps in `mapcycle.txt`, and the `Starting Map` should also be a Payload map.

Custom maps can be added under:

```text
\serverfiles\tf\maps
```

Clients need a way to download custom maps. For public servers, configure FastDL or keep the rotation to stock maps.
