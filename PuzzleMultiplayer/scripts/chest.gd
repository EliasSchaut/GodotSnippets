extends Node2D

@export var is_locked = true
@onready var chest_locked = $ChestLocked
@onready var chest_unlocked = $ChestUnlocked
@onready var key_spawn_marker = $KeySpawn
@onready var key_scene = preload("res://scenes/objects/key.tscn")

func _ready():
	_set_chest_properties()

func _unlock():
	is_locked = false
	var key = key_scene.instantiate()
	key_spawn_marker.add_child(key)
	_set_chest_properties()

func _set_chest_properties():
	chest_locked.visible = is_locked
	chest_unlocked.visible = not is_locked

func _on_chest_synchronizer_delta_synchronized():
	_set_chest_properties()

func _on_interactable_interacted():
	if not Lobby.is_server(): return
	if is_locked: _unlock()
