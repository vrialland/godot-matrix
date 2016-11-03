
extends Node2D

export var rows = 16
export var cols = 32
export var updates_per_minute = 60
var cell_size

onready var Led = preload('res://scenes/Led.tscn')
var led_grid = []
var elapsed = 0
var window_size = Vector2(0, 0)

func _ready():
	var size = OS.get_window_size()
	self.window_size = Vector2(size[0], size[1])
	var led_width = self.window_size.x / self.cols
	var led_height = self.window_size.y / self.rows

	for col in range(cols):
		var col_grid = []
		for row in range(rows):
			var led = Led.instance()
			led.set_pos(Vector2(led_width * col, led_height * row))
			led.set_random_color()
			col_grid.append(led)
			self.add_child(led)
		self.led_grid.append(col_grid)
	self.set_process(true)

func _on_draw():
	self.draw_rect(Rect2(Vector2(0, 0), self.window_size), Color(0, 0, 0))

func _process(delta):
	self.elapsed += delta
	if self.elapsed > 60.0 / self.updates_per_minute:
		self.elapsed = 0
		self.animate()

func animate():
	self.scroll_left()

func get_led_at(col, row):
	return self.led_grid[col][row]

func set_led_state(col, row, color, switched_on=true):
	var led = self.get_led_at(col, row)
	led.color = color
	led.switched_on = switched_on
	led.update()

func scroll_left():
	var buffer = []
	var col = 0
	var row = 0

	# get content of first col in memory
	for row in range(self.rows):
		var led = self.get_led_at(col, row)
		buffer.append([led.color, led.switched_on])

	# copy col + 1 to col
	for col in range(self.cols - 1):
		for row in range(self.rows):
			var src = self.get_led_at(col + 1, row)
			self.set_led_state(col, row, src.color, src.switched_on)

	# copy 1st col to last one
	col = self.cols - 1
	for row in range(self.rows):
		self.set_led_state(col, row, buffer[row][0], buffer[row][1])
