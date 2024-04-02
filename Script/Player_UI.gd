extends CanvasLayer

@onready var inhale_bar = $Inhale_bar
@onready var tummy_bar = $Tummy_bar
@onready var score_label = $"Score _Label"

func _process(delta):
	inhale_bar.value = GlobalScript.inhaler_value
	score_label.text = "Score: " + str(GlobalScript.total_score)
	tummy_bar.value = GlobalScript.tummy

func _on_area_2d_area_entered(area):
	if area.is_in_group("point_node"):
		area.queue_free()
		GlobalScript.total_score += area.properties.score
