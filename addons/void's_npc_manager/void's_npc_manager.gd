@tool
extends EditorPlugin

const ENGINE_AUTO = "NpcEngine"

func _enable_plugin() -> void:
	add_autoload_singleton(ENGINE_AUTO, "res://addons/void's_npc_manager/engine.gd")



func _disable_plugin() -> void:
	remove_autoload_singleton(ENGINE_AUTO)



func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
