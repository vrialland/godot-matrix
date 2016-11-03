
extends Node2D

export var color = Color(0, 0, 0, 255)
export var size = 24
export var switched_on = false

func _on_draw():
	if not self.switched_on:
		color = Color(0, 0, 0, 255)
	else:
		color = self.color
	var radius = self.size / 2
	self.draw_circle(Vector2(radius, radius), radius, color)

func set_random_color():
	self.color = Color(randi() * 255, randi() * 255, randi() * 255, 255)

func set_random_state():
	if randi() * 2 > 0:
		self.switched_on = true
	else:
		self.switched_on = false

func toggle():
	self.switched_on = not self.switched_on
