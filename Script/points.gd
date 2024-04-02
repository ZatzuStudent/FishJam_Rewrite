extends Area2D

var t = 0.0
var goPoint = false
var start_pos
@export var properties : Points
@onready var label = $Label

func _ready():
	start_pos = position
	await get_tree().create_timer(1.0).timeout
	goPoint = true
	label.text = str(properties.score)

func _physics_process(delta):
	if goPoint:
		t += delta * 1
		position = start_pos.lerp($"../../Camera2D".position + Vector2(600,-222), t)
