extends Node

@export var level_scene: PackedScene
@onready var ip_line_edit: LineEdit = $UI/HBoxContainer/IPEdit
@onready var status_label := $UI/Status
@onready var ui := $UI
@onready var host_button := $UI/HBoxContainer/HostButton
@onready var join_button := $UI/HBoxContainer/JoinButton
@onready var start_button := $UI/HBoxContainer/StartButton
@onready var level_container: Node = $Level

func _ready():
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_success)

func change_level(level_scene: PackedScene):
	for level in level_container.get_children():
		level_container.remove_child(level)
		level.queue_free()
	level_container.add_child(level_scene.instantiate())

@rpc("call_local", "authority", "reliable")
func hide_menu():
	ui.hide()

func _on_host_button_pressed():
	host_button.hide()
	join_button.hide()
	ip_line_edit.hide()
	start_button.show()
	Lobby.create_game()
	status_label.text = "Hosting!"

func _on_join_button_pressed():
	host_button.hide()
	join_button.hide()
	ip_line_edit.hide()
	Lobby.join_game(ip_line_edit.text)
	status_label.text = "Connecting..."

func _on_start_button_pressed():
	hide_menu.rpc()
	change_level.call_deferred(level_scene)

func _on_connection_failed():
	status_label.text = "Connection failed"
	host_button.show()
	join_button.show()
	ip_line_edit.show()

func _on_connected_success():
	status_label.text = "Connection successfull"
