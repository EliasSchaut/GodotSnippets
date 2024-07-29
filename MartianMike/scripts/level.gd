extends Node2D

@export var next_level: PackedScene = null
@export var level_time := 60
@export var is_final_level := false
@onready var start := $Start
@onready var exit := $Exit
@onready var deathzone := $Deathzone
@onready var ui = $UI
@onready var hud = $UI/HUD
const player_scene = preload("res://scenes/player.tscn")
var player_node: Player = null
var timer_node: Timer = null
var time_left: int
var win = false

func _ready():
	var traps := get_tree().get_nodes_in_group("traps")
	for trap: Trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)

	var player: Player = player_scene.instantiate()
	reset_player(player)
	player_node = player
	add_child(player)
	exit.body_entered.connect(_on_exit_player_entered)
	deathzone.body_entered.connect(_on_deathzone_player_entered)

	reset_level_time()
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func reset_player(player: Player):
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func reset_level():
	reset_player(player_node)
	reset_level_time()

func reset_level_time():
	time_left = level_time
	hud.set_time_label(time_left)
	AudioPlayer.play_sfx("hurt")

func _on_deathzone_player_entered(player: Player):
	reset_level()

func _on_trap_touched_player(player: Player):
	reset_level()

func _on_exit_player_entered(player: Player):
	player.active = false
	win = true
	if next_level || is_final_level:
		await get_tree().create_timer(1.5).timeout
		if is_final_level:
			ui.show_win_screen()
		else:
			get_tree().change_scene_to_packed(next_level)

func _on_level_timer_timeout():
	if !win:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset_level()
