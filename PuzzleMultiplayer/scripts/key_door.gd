extends Node2D

@export var is_open = false
@onready var door_closed = $DoorClosed
@onready var door_open = $DoorOpen

func open():
	if not Lobby.is_server() && is_open: return
	is_open = true
	_set_door_properties()

func _set_door_properties():
	door_open.visible = is_open
	door_closed.visible = not is_open

func _on_key_door_synchronizer_delta_synchronized():
	_set_door_properties()

func _on_area_2d_key_entered(key):
	open()
	key.get_owner().queue_free()
