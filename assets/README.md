# Godot Asset Staging

These files are direct exports from the original GameMaker project (`chemistris-gms`) staged for Godot 4 import.

## Sprites
- Location: `assets/sprites/<sprite_name>/`
- Naming: `spr_<name>_NN.png` where `NN` is a zero-padded frame index; single frame sprites omit the suffix.
- Source: Copied from `chemistris-gms/sprites/<sprite_name>/*.png`.
- Counts:
  - spr_HT – 22 frames
  - spr_HTHP – 1 frame
  - spr_arrow – 1 frame
  - spr_background_level – 1 frame
  - spr_background_menu – 1 frame
  - spr_check – 1 frame
  - spr_elec – 7 frames
  - spr_fire – 7 frames
  - spr_heat – 4 frames
  - spr_light – 13 frames
  - spr_page_fail – 1 frame
  - spr_page_success – 1 frame
  - spr_tileset_Atom – 1 frame
  - spr_tileset_banned – 1 frame
  - spr_tileset_bond – 1 frame
  - spr_tileset_counter – 1 frame
  - spr_tileset_locked – 1 frame
  - spr_tileset_mole – 1 frame
  - spr_tileset_passed – 1 frame
  - spr_tileset_unlocked – 1 frame
  - sprite30 – 1 frame

## Audio
- Location: `assets/audio/`
- `snd_cyber.mp3` copied from `chemistris-gms/sounds/snd_cyber/snd_cyber.mp3`.

## Fonts
- Location: `assets/fonts/`
- `IBMPlexSansCondensed.ttf` copied from `chemistris-gms/datafiles`.

## Next Actions
- Convert animation strips to Godot `SpriteFrames` resources during Phase 3.
- Evaluate whether additional audio cues need export once Godot build exposes new interactions.
