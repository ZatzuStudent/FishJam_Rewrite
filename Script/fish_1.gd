extends CharacterBody2D
class_name Fish
@export var properties : Fishies
@onready var fish_sprite = $Fish_Sprite
@onready var viewer_area = $Viewer_Area2D

@export var points : PackedScene

var inhalte_area = false
var sucked = false

var direction = Vector2.ZERO
var chase_speed

func _ready():
	direction.x = randi_range(1,3) if global_position.x < 0 else randi_range(-1,-3)
	direction.y = randi_range(-3,3)

func _process(delta):
	inhaled()
	toMove()
	if !sucked:
		flipit()

func toMove():
	var new_dir = direction
	if !nearPlayer:
		var max_direction = new_dir.clamp( Vector2(-3, -1), Vector2(3, 1))
		if direction != max_direction:
			direction = direction/1.1
	else:
		chasing_player()
		
	velocity = properties.speed * direction
	move_and_slide()
@onready var body_collision = $Body_Collision

func flipit():
	var pos = 1 if velocity.x > 0 else -1 if velocity.x < 0 else fish_sprite.scale.x
	fish_sprite.scale.x = scale.x*pos
	viewer_area.scale.x = scale.x*pos
	body_collision.position.x = properties.body_pos if velocity.x > 0 else -properties.body_pos if velocity.x < 0 else body_collision.position.x
	
func rev_flipit():
	var pos = -1 if velocity.x > 0 else 1 if velocity.x < 0 else fish_sprite.scale.x
	fish_sprite.scale.x = scale.x*pos
	viewer_area.scale.x = scale.x*pos
	body_collision.position.x = properties.body_pos if velocity.x < 0 else -properties.body_pos if velocity.x > 0 else body_collision.position.x

func _on_dir_timer_timeout():
	direction.y = randi_range(-3,3)

var nearPlayer = false
func _on_viewer_area_2d_body_entered(body):
	if body is Player && !sucked:
		if body.properties.size > properties.size:
			chase_speed = 30
		else:
			chase_speed = -10
		nearPlayer = true

func chasing_player():
	if get_parent().get_parent().has_node("Player"):
		direction = (-(($"../../Player".global_position - global_position).normalized()))*chase_speed
	else:
		nearPlayer = false

func _on_viewer_area_2d_body_exited(body):
	if body is Player:
		direction = direction/1.5
		await get_tree().create_timer(1.5).timeout
		nearPlayer = false

func _on_mouth_area_2d_body_entered(body):
	if body is Player && properties.size >= body.properties.size:
		body.eaten()

func eaten():
	var instance = points.instantiate()
	instance.position = position
	call_deferred("add_sibling", instance)
	queue_free()
	
func inhaled():
	if Input.is_action_pressed("inhale") && inhalte_area && GlobalScript.inhaler_value > 0:
		sucked = true
		direction = ($"../../Player".global_position- global_position).normalized()*10
		rev_flipit()
	else:
		sucked = false

func inHale_area():
	inhalte_area = true

func outHale_area():
	inhalte_area = false
	
