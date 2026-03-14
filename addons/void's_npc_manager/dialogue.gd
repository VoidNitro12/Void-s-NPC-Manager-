@tool
extends Node

## WARM = friendly, expressive, curious and patient. [br]
## GENTLE = friendly, expressive, neutral curious and patient. [br]
## COLD = unfriendly, not expressive, neutraly curious and not patient. [br]
## HOSTILE = unfriendly, expressive, not curious, and not patient. [br]
## DISTANT = neutraly friendly, neutral expressiveness, neutral curiousity and neutral patience. [br]
## EAGER = friendly, expressive, curious and not patient. [br]
## DETACHED = unfriendly,neutral expressiveness, neutral curiousity and neutral patience. [br]
## TERSE = neutraly friendly, not expressive, not curious and not patient. [br]
enum descriptor {WARM, GENTLE, COLD, HOSTILE, DISTANT, EAGER, DETACHED, TERSE}


var _dialogue_pool_event = {}

var _dialogue_pool_character = {}

func add_dialogue_event(event_type: String, lines: Array):
	var valid_type = NpcEngine.custom_event_types.has(event_type)
	assert(valid_type, "No such event type %s. see NpcEngine.add_event_type() to make one" %event_type)
	_dialogue_pool_event[event_type] = lines

func dialogue_event_format(event_type: String, line: String) -> String:
	var event= NpcEngine._custom_event_types[event_type]
	for key in event:
		var formatted_key = "{%s}" %key
		if line.contains(formatted_key):
			line = line.replace(formatted_key,event[key])
	return line



func apply_mood(npc: Dictionary) -> Dictionary:
	var traits = ["friendliness", "expressiveness", "patience", "curiosity"]
	for value in traits:
		var base = npc[value]
		var min_val = base - npc.personality_range
		var max_val = base + npc.personality_range
		npc[value] = clampf(base + npc.mood, min_val, max_val)
	return npc

func _vibe_band(value: float, range: String) -> bool:
	var range_float = []
	if range == "high" : 
		range_float = [0.7,1.0]
	elif range == "neutral": 
		range_float = [0.4,0.7]
	elif range == "low": 
		range_float = [0.0,0.4]
	var result = false
	var low = range_float[0]
	var high = range_float[1]
	if value < high and value > low:
		result = true
	return result

func _vibe_map(npc: Dictionary):
	var vibe
	var f = npc.friendliness
	var e = npc.expressiveness
	var p = npc.patience
	var c = npc.curiosity
	if _vibe_band(f, "high") and _vibe_band(e, "high")  and _vibe_band(p, "high") and _vibe_band(c, "high"):
		vibe = descriptor.WARM
	elif _vibe_band(f, "high") and _vibe_band(e, "high") and _vibe_band(p, "high") and _vibe_band(c, "neutral"):
		vibe = descriptor.GENTLE
	elif _vibe_band(f, "low") and _vibe_band(e, "low") and _vibe_band(p, "low") and _vibe_band(c, "low"):
		vibe = descriptor.COLD
	elif _vibe_band(f, "low") and _vibe_band(e, "high") and _vibe_band(p, "low") and _vibe_band(c, "low"):
		vibe = descriptor.HOSTILE
	elif _vibe_band(f, "neutral") and _vibe_band(e, "neutral") and _vibe_band(p, "neutral") and _vibe_band(c, "neutral"):
		vibe = descriptor.DISTANT
	elif _vibe_band(f, "high") and _vibe_band(e, "high") and _vibe_band(p, "low") and _vibe_band(c, "high"):
		vibe = descriptor.EAGER
	elif _vibe_band(f, "neutral") and _vibe_band(e, "low") and _vibe_band(p, "low") and _vibe_band(c, "low"):
		vibe = descriptor.TERSE
	elif _vibe_band(f, "low") and _vibe_band(e, "neutral") and _vibe_band(p, "neutral") and _vibe_band(c, "neutral"):
		vibe = descriptor.DETACHED
	else:
		push_warning("No match found, using default of Distant")
		vibe = descriptor.DISTANT
	return vibe.key()

func query_event(event_id: String, npc: Dictionary, vibe) -> Array:
	var data = NpcEngine.get_event(event_id)
	var event = data[0]
	var pool
	if npc.id in event.direct_witness:
		pool = _dialogue_pool_event[event.type]["direct"][vibe]
	elif npc.id in event.indirect_witness:
		pool = _dialogue_pool_event[event.type]["indirect"][vibe]
	else:
		pool = _dialogue_pool_event["UNAWARE"][vibe]
	return [pool,event.type]
	
func query_char(target_id: String, npc: Dictionary, vibe) -> Array:
	var data = NpcEngine.get_npc(target_id)
	var target = data[0]
	var pool
	var sel_char = npc.relationshipd[target_id].type
	if npc.relationships.has(target_id):
		pool = _dialogue_pool_character[sel_char][vibe]
	else:
		pool = _dialogue_pool_character["UNAWARE"][vibe]
	return [sel_char]

func talk_to_npc(npc: Dictionary, id: String, event_based: bool = false, char_based: bool = false):
	var pool
	var data
	var current_npc = apply_mood(npc)
	var vibe =  _vibe_map(current_npc)
	if event_based:
		data = query_event(id, current_npc,vibe)
		pool = data[0]
	if char_based:
		data = query_char(id, current_npc,vibe)
		pool = data[0]
	var choice_index = randi() % pool.size()
	var choice = pool[choice_index]
	if event_based:
		var type = data[1]
		choice = dialogue_event_format(type, choice)
	if char_based:
		var type = pool[1]
		# I REALLY NEED TO RETHINK RELATIONSHIPS
	return choice
