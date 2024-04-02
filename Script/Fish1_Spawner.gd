extends Node2D

@export var fish_1 : PackedScene
@export var fish_2 : PackedScene
@export var fish_3 : PackedScene



func _on_timer_timeout():
	var instance = fish_1.instantiate()
	instance.position = $Spawn_Point_1.position
	call_deferred("add_child", instance)
	var instance1 = fish_1.instantiate()
	instance1.position = $Spawn_Point_3.position
	call_deferred("add_child", instance1)


func _on_timer_2_timeout():
	var instance = fish_2.instantiate()
	instance.position = $Spawn_Point_2.position
	call_deferred("add_child", instance)
