
extends Node2D

export var color = Color(0, 255, 0, 255)
export var size = 26

func _on_draw():
	var radius = self.size / 2
	self.draw_circle(Vector2(radius, radius), radius, self.color)

func set_color(color):
	self.color.r = color.r
	self.color.g = color.g
	self.color.b = color.b
	self.update()

func set_color_with_alpha(color):
	self.color = color
	self.update()

func toggle():
	if self.color.a > 0:
		self.off()
	else:
		self.on()

func on():
	self.color.a = 255
	self.update()

func off():
	self.color.a = 60
	self.update()

func copy(other):
	self.set_color_with_alpha(other.color)
