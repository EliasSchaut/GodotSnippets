class_name Player extends CharacterBody2D

@export var player_camera: PackedScene
@export var movement_speed = 300
@export var gravity = 30
@export var jump_strength = 600
@export var max_jumps = 2
@export var push_force = 10
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var initial_sprite_scale = player_sprite.scale

var owner_id = 1
var jump_count = 0
var camera_instance: Camera2D
var camera_height = -300
var state = PlayerState.IDLE
var currenct_interactable = null


enum PlayerState {
	IDLE,
	WALKING,
	JUMP_STARTED,
	JUMPING,
	DOUBLE_JUMPING,
	FALLING
}

func _enter_tree():
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)
	if !is_owner():
		return

	_set_up_camera()

func _process(delta):
	if not is_owner():
		return
	_update_camera_position()

func _physics_process(_delta):
	if not is_owner():
		return
	var horizontal_input = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)

	velocity.x = horizontal_input * movement_speed
	velocity.y += gravity

	if Input.is_action_just_pressed("interact") && currenct_interactable != null:
		currenct_interactable.interact.rpc_id(Lobby.SERVER_ID)

	handle_movement_state()
	move_and_slide()
	face_movement_direction(horizontal_input)


func _on_animated_sprite_2d_animation_finished():
	if state == PlayerState.JUMPING:
		player_sprite.play("jump")

func face_movement_direction(horizontal_input):
	if not is_zero_approx(horizontal_input):
		if horizontal_input < 0:
			player_sprite.scale = Vector2(-initial_sprite_scale.x, initial_sprite_scale.y)
		else:
			player_sprite.scale = initial_sprite_scale

func handle_movement_state():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = PlayerState.JUMP_STARTED
	elif is_on_floor() and is_zero_approx(velocity.x):
		state = PlayerState.IDLE
	elif is_on_floor() and not is_zero_approx(velocity.x):
		state = PlayerState.WALKING
	else:
		state = PlayerState.JUMPING

	if velocity.y > 0.0 and not is_on_floor():
		if Input.is_action_just_pressed("jump"):
			state = PlayerState.DOUBLE_JUMPING
		else:
			state = PlayerState.FALLING

	match state:
		PlayerState.IDLE:
			player_sprite.play("idle")
			jump_count = 0
		PlayerState.WALKING:
			player_sprite.play("walk")
			jump_count = 0
		PlayerState.JUMP_STARTED:
			player_sprite.play("jump_start")
			jump_count += 1
			velocity.y = -jump_strength
		PlayerState.JUMPING:
			pass
		PlayerState.DOUBLE_JUMPING:
			jump_count += 1
			if jump_count <= max_jumps:
				player_sprite.play("double_jump_start")
				velocity.y = -jump_strength
		PlayerState.FALLING:
			player_sprite.play("fall")

	# Jump Cancelling
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y = 0.0

func _set_up_camera():
	camera_instance = player_camera.instantiate()
	camera_instance.global_position.y = camera_height
	get_tree().current_scene.add_child.call_deferred(camera_instance)

func _update_camera_position():
	camera_instance.global_position.x = global_position.x

func is_owner():
	return multiplayer.multiplayer_peer != null && owner_id == multiplayer.get_unique_id()

func _on_interaction_handler_interactable_entered(area):
	currenct_interactable = area

func _on_interaction_handler_interactable_exited(area):
	if currenct_interactable == area:
		currenct_interactable = null
