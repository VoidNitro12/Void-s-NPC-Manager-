@tool
extends Resource
class_name ScriptData

var event_dialogue_lookup: Dictionary
var npc_dialogue_lookup: Dictionary

func save_lookup(script_type: int, lookup: Dictionary):
	match script_type:
		NpcDialogue.PoolType.EVENT:
			event_dialogue_lookup = lookup
		NpcDialogue.PoolType.NPC:
			npc_dialogue_lookup = lookup
		_:
			push_error("Invalid PoolType see NpcDialogue.PoolType")
			return
