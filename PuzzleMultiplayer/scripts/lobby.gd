extends Node

signal player_connencted(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7000
const MAX_CONNECTIONS = 2
const SERVER_ID = 1

var players = {}
var player_info = { "name": "Name" }

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connections_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var connection_error = peer.create_server(PORT, MAX_CONNECTIONS)
	if connection_error:
		return connection_error
	multiplayer.multiplayer_peer = peer
	players[multiplayer.get_unique_id()] = player_info
	player_connencted.emit(multiplayer.get_unique_id(), player_info)

func join_game(address):
	var peer = ENetMultiplayerPeer.new()
	var connection_error = peer.create_client(address, PORT)
	if connection_error:
		return connection_error
	multiplayer.multiplayer_peer = peer

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connencted.emit(new_player_id, new_player_info)

func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_to_server():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connencted.emit(peer_id, player_info)

func _on_connections_failed():
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	server_disconnected.emit()

func is_server():
	return multiplayer.multiplayer_peer != null && multiplayer.is_server()
