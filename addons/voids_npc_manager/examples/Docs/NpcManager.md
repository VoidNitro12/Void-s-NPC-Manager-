# NpcManager API Reference

Core singleton for managing NPCs, events, relationships, and save data.


## Setup

### set_npc_saves(path: String)
Sets folder for NPC `.tres` files. Absolute path only. Creates folder if missing.

### set_event_saves(path: String)
Sets folder for Event `.tres` files. Absolute path only.

### set_data_saves(file_name: String, path: String)
Sets file for plugin metadata (custom fields, player data, counters).
- `file_name`: e.g., `"plugin_data.tres"`
- `path`: folder path

### set_player_name(name: String)
Sets player name for use in dialogue placeholders (`{player0}`).

### set_time_format(use_24hr: bool = true)
Switches between 24hr (`true`) and 12hr (`false`) time display.

### update_game_time(hour: int, minute: int, meridian: String = "AM")
Updates internal game time. If using 12hr format, provide `"AM"` or `"PM"`.


## NPCs

### add_npc(npc_info: Dictionary)
Creates a new NPC. Required fields:
- `"name"`: String
- `"friendliness"`: int (0-100)
- `"expressiveness"`: int (0-100)
- `"patience"`: int (0-100)
- `"curiosity"`: int (0-100)
- `"mood"`: int (-15 to 15)
- `"personality_range"`: int (30-40)

### add_npc_field(field: String)
Adds custom field to all NPCs (e.g., `"job"`, `"age"`). Access via `npc.custom["field_name"]`.

### remove_npc_field(field: String)
Removes a custom NPC field.

### get_npc(npc_id: String) -> Resource
Loads and returns NPC resource by ID.

### get_npc_by_name(name: String) -> Resource
Returns first NPC found with matching name. Returns `null` if not found.

### get_all_npc_by_name(name: String) -> Dictionary
Returns dictionary of all NPCs with matching name, keyed by ID.

### get_npc_fields() -> Array
Lists all registered custom NPC fields.

### remove_npc(npc_id: String)
Permanently deletes NPC. IDs are never reused.

### num_npc() -> int
Returns total number of NPCs.


## Events

### add_event_type(type: String, type_values: Array)
Registers custom event type.
- `type`: e.g., `"fight"`
- `type_values`: e.g., `["fighter1", "fighter2", "cause"]`

### remove_event_type(type: String)
Removes an event type.

### add_event_field(field: String)
Adds custom field to all events (e.g., `"importance"`).

### remove_event_field(field: String)
Removes a custom event field.

### add_event(event_info: Dictionary, event_type_info: Array, involve_player: bool = false, player_type: String = "none")
Creates a new event. See Getting Started for full example.
- `event_info` requires: `name`, `type`, `description`, `time`, `date`, `day`, `where`, `direct_witness`, `indirect_witness`
- `player_type`: `"direct_events"` or `"indirect_events"` if `involve_player = true`

### get_event(event_id: String) -> Resource
Loads and returns event resource by ID.

### get_event_fields() -> Array
Lists all registered custom event fields.

### get_event_types() -> Array
Lists all registered event type names.

### remove_event(event_id: String)
Permanently deletes event. IDs are never reused.

### num_events() -> int
Returns total number of events.



## Relationships

### add_relationship_type(type: String)
Registers relationship type (e.g., `"friend"`, `"rival"`).

### update_npc_relationship(npc: String, target: String, value: int, type: String)
Updates relationship between two NPCs, or NPC and player.
- `npc`: NPC ID or name
- `target`: NPC ID/name, or `"player"`
- `value`: 0-100
- `type`: Must match a registered relationship type

### get_npc_relationship(npc_1: Variant, npc_2: Variant) -> Array
Returns `[relationship_from_npc1, relationship_from_npc2]`. Returns empty dicts if no relationship exists.



## Player Data

### update_player_events(event_type: String, event_id: String)
Adds event to player's history.
- `event_type`: `"direct_events"` or `"indirect_events"`


## Save/Load

### save_plugin_data()
Saves current plugin state (custom fields, counters, paths) to `.tres` file.

### load_plugin_data(merge: bool = false)
Loads saved plugin data.
- `merge`: `true` preserves existing data where no conflict (currently not fully implemented)


## Dialogue Conditions

### register_dialogue_condition(condition_text: String, callable: Callable)
Registers custom condition for dialogue branching.
```gdscript
register_dialogue_condition("is_friendly", _check_friendly)
func _check_friendly(npc) -> bool:
    return npc.friendliness > 50
