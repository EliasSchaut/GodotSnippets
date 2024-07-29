extends Node2D

@onready var players_container := $Players/PlayersContainer
@onready var spawn_points: Array[Marker2D] = [$Players/SpawnPoint1, $Players/SpawnPoint2]
const player_scene := preload("res://scenes/player.tscn")
var _next_spawn_point_index = 0

func _ready():
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)

	for id in multiplayer.get_peers():
		add_player(id)
	add_player(multiplayer.get_unique_id())

func _exit_tree():
	if not Lobby.is_server():
		return
	multiplayer.peer_disconnected.disconnect(delete_player)

func add_player(id):
	var player_node = player_scene.instantiate()
	player_node.global_position = get_spawn_point()
	player_node.name = str(id)
	players_container.add_child(player_node)

func delete_player(id):
	if not players_container.has_node(str(id)):
		return
	players_container.get_node(str(id)).queue_free()

func get_spawn_point():
	var spawn_point = spawn_points[_next_spawn_point_index].global_position
	_next_spawn_point_index += 1
	if _next_spawn_point_index >= len(spawn_points):
		_next_spawn_point_index = 0
	return spawn_point
