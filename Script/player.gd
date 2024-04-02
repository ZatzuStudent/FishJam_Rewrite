extends CharacterBody2D
class_name Player
@export var properties : Fishies

@onready var player_sprite = $Player_Sprite
@onready var viewer_area = $Viewer_Area2D/CollisionPolygon2D
@onready var body_collision = $Body_Collision

func _ready():
	await get_tree().create_timer(.5).timeout

func _physics_process(delta):
	flipit()
	for_mouse_movement()
	dash()
	inhaled(delta)
	tummy_size()

var inDash = false
var inHale = false
var direction = Vector2.ZERO

func for_mouse_movement():
	#to stay in area
	global_position = global_position.clamp(Vector2(-1506, -484), Vector2(1506, 484))
	#to move
	var new_dir = Vector2.ZERO
	if !inDash && !inHale:
		if direction.length() > 5:
			velocity = properties.speed * direction
		else:
			velocity = velocity/1.01
	var max_direction = new_dir.clamp( Vector2(-3, -2), Vector2(3, 2))
	if direction != max_direction:
			direction = direction/1.1
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		direction = event.relative


func flipit():
	var pos = 1 if velocity.x > 0 else -1 if velocity.x < 0 else player_sprite.scale.x
	player_sprite.scale.x = pos
	viewer_area.scale.x = pos
	body_collision.position.x = properties.body_pos if velocity.x > 0 else -properties.body_pos if velocity.x < 0 else body_collision.position.x
	
@onready var bubbles = $Bubbles

func dash():
	var new_vel
	var max_vel = 1000
	if Input.is_action_just_pressed("dash") && !inDash:
		inDash = true
		bubbles.emitting = true
		new_vel = velocity * 7000
		velocity = new_vel.clamp( Vector2(-max_vel, -max_vel/1.5), Vector2(max_vel, max_vel/1.5))
		await get_tree().create_timer(.2).timeout
		velocity = velocity/2
		bubbles.emitting = false
		inDash = false

@onready var inhale_bar = $Inhale_bar

func eaten():
	GlobalScript.lives -= 1
	queue_free()

func _mouth_area_body_entered(body):
	if body is Fish && properties.size > body.properties.size:
		body.eaten()
		GlobalScript.tummy += body.properties.meal_value

func inhaled(delta):
	if Input.is_action_pressed("inhale"):
		inhale_bar.value -= delta*60
		inHale = true
		velocity = velocity/2
	else:
		inHale = false
		inhale_bar.value += delta*10
	GlobalScript.inhaler_value = inhale_bar.value

func _on_viewer_area_2d_body_entered(body):
	if properties.size > body.properties.size:
		if body is Fish && properties.size > body.properties.size:
			body.inHale_area()

func _on_viewer_area_2d_body_exited(body):
	if body is Fish && properties.size > body.properties.size:
		body.outHale_area()

var boom = 0
func tummy_size():
	print(scale)
	print(boom)
	if boom == 1:
		if GlobalScript.tummy >= 60:
			boom = 2
			properties.size = 4
			scale = scale*1.5
	if boom == 0:
		if GlobalScript.tummy >= 30:
			boom = 1
			properties.size = 3
			scale = scale*1.5
