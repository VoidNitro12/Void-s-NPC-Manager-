# Voids NPC Manager v0.2.1
- Fixed `_apply_mood()` in dialogue.gd not using base trait values for min/max clamps
- Changed NPC trait values from floats (0.0-1.0) to ints (0-100) in NpcData.gd and engine.gd
- Reworked `_vibe_map()` in dialogue.gd for fuzzy matching (prevents excessive DISTANT fallbacks)
- Updated `update_npc_relationship()` in engine.gd to accept ints (0-100) instead of floats

# Dgpool Extension v0.1.1
- Fixed `_check_fields()` dictionary validation in parser.gd
- Fixed pool type locator issues in `pool_request()`
- Renamed `EVENT_MARKER` to `TYPE_MARKER` across all files (scripts now use `@` marker)
- Added pool type validation (EVENT vs NPC) in parser_validator.gd
- Improved error handling in parser validation
