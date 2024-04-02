extends Camera2D

@onready var player = $"../Player"

func _ready():
	Engine.physics_ticks_per_second = DisplayServer.screen_get_refresh_rate()

func _process(_delta):
	if get_parent().has_node("Player"):
		global_position.x = clamp(player.global_position.x, -1367, 1367)
		global_position.y = clamp(player.global_position.y, -438, 438)

