class_name Validator

var regex = RegEx.new()
var response_format = "\"([^\"]+)\"\\s*(\\{[^\\}]+\\})"
var pool_type
var has_pool_type = false
var in_type = false
var in_vibe = false
var in_mode = false
var in_section = false
var in_npc_line = false
var in_response = false

func token_validation(tokens: Array):
	
	regex.compile(response_format)
	var valid
	var checks = []
	
	for token in tokens:
		if token.marker == Lexer.POOL_MARKER:
			valid = _check_pool(token)
			checks.append(valid)
		elif token.marker == Lexer.TYPE_MARKER:
			valid = _check_type(token)
			checks.append(valid)
		elif token.marker == Lexer.VIBE_MARKER:
			valid = _check_vibe(token)
			checks.append(valid)
		elif token.marker == Lexer.MODE_MARKER:
			valid = _check_mode(token)
			checks.append(valid)
		elif token.marker == Lexer.SECTION_MARKER:
			valid = _check_section(token)
			checks.append(valid)
		elif token.marker == Lexer.NPC_LINE_MARKER:
			valid = _check_npc_line(token)
			checks.append(valid)
		elif token.marker == Lexer.RESPONSE_MARKER:
			valid = _check_response(token)
			checks.append(valid)
	assert(checks.has(false) == false, "Unable to parse pool script due to errors")
func _check_pool(token):
	if has_pool_type:
		push_error("Pool Type on line %d when pool type already exists"%token.line_num)
		return false
	match token.value:
		"EVENT":
			pool_type = NpcDialogue.PoolType.EVENT
		"NPC":
			pool_type = NpcDialogue.PoolType.NPC
		_:
			push_error("Invalid Pool Type on line %d, should be EVENT or NPC"%token.line_num)
			has_pool_type = false
			return false
	has_pool_type = true
	return true

func _check_type(token):
	_reset_flags()
	if not has_pool_type:
		push_error("No valid pool type to place type on line %d under"%token.line_num)
		in_type = false
		return false
	match pool_type:
		NpcDialogue.PoolType.EVENT:
			if token.value not in NpcManager._event_types:
				push_error("Invalid Pool type on line %d. see NpcManager.get_event_types() " %token.line_num)
				in_type = false
				return false
		NpcDialogue.PoolType.NPC:
			if token.value  not in NpcManager._relationship_types:
				push_error("Invalid Relationship Type on line %d. see NpcManager.get_event_types() " %token.line_num)
				in_type = false
				return false
	in_type = true
	return true

func _check_vibe(token):
	if not in_type:
		push_error("No valid type to place Descriptor under on line %d"%token.line_num)
		in_vibe = false
		return false
	if token.value not in NpcDialogue.Vibe.keys():
		push_error("Invalid Emotional Descriptor on line %d" %token.line_num)
		in_vibe = false
		return false
	in_vibe = true
	return true

func _check_mode(token):
	if not in_vibe:
		push_error("No valid Emotional Descriptor to place Context under on line %d"%token.line_num)
		in_mode = false
		return false
	if token.value not in NpcDialogue.PoolContext.keys():
		push_error("Invalid Pool Context on line %d" %token.line_num)
		in_mode = false
		return false
	in_mode = true
	return true

func _check_section(token):
	if not in_mode:
		push_error("No valid Pool Context to place sectiont under on line %d"%token.line_num)
		in_section = false
		return false
	in_section = true
	return true

func _check_npc_line(token):
	if not in_section:
		push_error("No valid Section to place NPC line under on line %d"%token.line_num)
		in_npc_line = false
		return false
	var text = token.value
	if not text.begins_with("\"") or not text.ends_with("\""):
		push_error("NPC line must be contained in qoutes with no other statements, line %d"%token.line_num)
		in_npc_line = false
		return false
	in_npc_line = true
	return true

func _check_response(token):
	if not in_npc_line:
		push_error("No valid NPC line to place response under, line %d"%token.line_num)
		in_response = false
		return false
	var line = token.value
	var found = regex.search(line)
	if found == null:
		push_error("Invalid syntax for response on line %d"%token.line_num)
		in_response = false
		return false
	var text = found.get_string(1)
	var meta_raw = found.get_string(2)
	
	if not text.begins_with("\"") or not text.ends_with("\""):
		push_error("Response text must be contained in qoutes with no other statements, line %d"%token.line_num)
		in_npc_line = false
	var meta = JSON.parse_string(meta_raw)
	if meta == null:
		push_error("Invalid Meta Data Formating on Line %d"%token.line_num)
		in_response = false
		return false
	in_response = true
	return true

func _reset_flags():
	in_type = false
	in_vibe = false
	in_mode = false
	in_section = false
	in_npc_line = false
	in_response = false
