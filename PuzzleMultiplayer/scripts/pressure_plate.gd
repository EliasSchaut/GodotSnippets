extends Node2D

signal toggle(is_pressed: bool)

@export var is_pressed = false
@onready var plate_up_sprite = $PlateUp
@onready var plate_down_sprite = $PlateDown
var players_on_plate = 0

func _set_plate_properties():
	if is_pressed:
		_draw_plate_down()
	else:
		_draw_plate_up()

func _update_plate_state():
	is_pressed = players_on_plate > 0
	toggle.emit(is_pressed)
	_set_plate_properties()

func _draw_plate_down():
	plate_down_sprite.show()
	plate_up_sprite.hide()

func _draw_plate_up():
		plate_down_sprite.hide()
		plate_up_sprite.show()

func _on_hitbox_player_entered(body: Player):
	if not Lobby.is_server(): return
	players_on_plate += 1
	_update_plate_state()

func _on_hitbox_player_exited(body):
	if not Lobby.is_server(): return
	players_on_plate -= 1
	_update_plate_state()

func _on_plate_synchronizer_synchronized():
	_set_plate_properties()
