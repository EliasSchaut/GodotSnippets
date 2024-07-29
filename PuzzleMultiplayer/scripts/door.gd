extends Node2D

@export var is_open = false
@onready var door_closed = $DoorClosed
@onready var door_open = $DoorOpen
@onready var door_closed_collider = $DoorClosed/StaticBody2D/CollisionShape2D

func activate(state: bool):
	if not Lobby.is_server(): return
	is_open = state
	_set_door_properties()

func _set_door_properties():
	door_open.visible = is_open
	door_closed.visible = not is_open
	door_closed_collider.set_deferred("disabled", is_open)

func _on_door_synchronizer_delta_synchronized():
	_set_door_properties()
