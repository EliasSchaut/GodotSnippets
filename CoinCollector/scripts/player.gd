extends CharacterBody2D

@export var SPEED = 30.0
@export var MAXCOINS = 9
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var countdown = $Countdown
@onready var winlabel := $WinLabel

func _physics_process(delta: float):
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (Input.is_action_pressed("ui_right") && sprite.scale.x >= 0): sprite.scale.x *= -1 
	elif (Input.is_action_pressed("ui_left")  && sprite.scale.x <= 0): sprite.scale.x *= -1
	velocity = direction * SPEED * delta
	move_and_slide()

func coin_collected():
	sprite.scale *= 1.1
	collision.scale *= 1.1
	MAXCOINS -= 1
	if (MAXCOINS == 0):
		countdown.stop_timer()
		winlabel.visible = true
		
