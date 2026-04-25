# Getting Started
To use this plugin, create a setup function to define your custom fields, event types, and save paths **before** loading any NPCs or events.

## Example Setup

```gdscript
func setup_NpcManager():
	# Save Paths 
	NpcManager.set_npc_saves("res://Game_manager/NPCs/")
	NpcManager.set_event_saves("res://Game_manager/Events/")
	NpcManager.set_data_saves("NpcManager_data.tres", "res://Game_manager/")

	# Player Data
	NpcManager.set_player_name("Player")

	# Custom NPC Fields
	var npc_fields = ["age","gender","energy","traits"]
	for field in npc_fields:
		NpcManager.add_npc_field(field)

	# Event Types and Fields
	NpcManager.add_event_type("fight", ["fighter1", "fighter2", "cause"])
	NpcManager.add_event_type("celebration", ["organizer", "reason"])
	NpcManager.add_event_field("importance")
```

## Notes

- Save paths are folders (except set_data_saves which takes a filename + folder)
- Custom fields become accessible via `npc.custom["field_name"]`
- Make sure to call setup_NpcManager() before using any other NpcManager functions
- Usually in an autoload or your main scene's _ready()
