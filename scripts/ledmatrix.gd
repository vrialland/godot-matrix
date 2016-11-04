
extends Node2D

export var rows = 16
export var cols = 32
export var updates_per_minute = 60

onready var Led = preload('res://scenes/Led.tscn')

var _grid = []
var elapsed = 0
var cell_size
var window_size = Vector2(0, 0)

func _get_index_from_coords(col, row):
	return row * self.cols + col

func _get_coords_from_index(i):
	return [i % self.cols, i / self.cols]

func set_led_at(col, row, led):
	self._grid[self._get_index_from_coords(col, row)] = led

func get_led_at(col, row):
	return self._grid[self._get_index_from_coords(col, row)]

func _ready():
	var width = int(self.window_size.x)
	var height = int(self.window_size.y)

	var size = OS.get_window_size()
	self.window_size = Vector2(size[0], size[1])
	var cell_width = self.window_size.x / self.cols
	var cell_height = self.window_size.y / self.rows
	var delta_x = null
	var delta_y = null

	# Init led grid
	for i in range(self.cols * self.rows):
		# col, row
		var coords = self._get_coords_from_index(i)
		var led = Led.instance()
		if delta_x == null:
			delta_x = (cell_width - led.size) / 2
			delta_y = (cell_height - led.size) / 2

		self._grid.append(led)
		led.set_pos(Vector2(cell_width * coords[0] + delta_x, cell_height * coords[1] + delta_y))
		self.add_child(led)

	for i in range(self.rows):
		self.get_led_at(i, i).on()

	self.set_process(true)

func _on_draw():
	# Fill background with black
	self.draw_rect(Rect2(Vector2(0, 0), self.window_size), Color(0, 0, 0))

func _process(delta):
	self.elapsed += delta
	if self.elapsed > 60.0 / self.updates_per_minute:
		self.elapsed = 0
		self.horizontal_scroll(4, 12)

func set_led_color(col, row, color):
	var led = self.get_led_at(col, row)
	led.set_color(color)

func horizontal_scroll(start_row=0, end_row=rows, left_to_right=false):
	var buffer = []
	var col = 0
	var row = 0

	if left_to_right:
		col = self.cols - 1

	# get content of first col (right to left) or last one in memory
	for row in range(0, self.rows):
		var led = self.get_led_at(col, row)
		buffer.append(led.color)

	if left_to_right:
		# copy col - 1 to col
		for col in range(self.cols - 1, 0, -1):
			for row in range(start_row, end_row):
				var src = self.get_led_at(col - 1, row)
				self.get_led_at(col, row).copy(src)
	else:
		# copy col + 1 to col
		for col in range(self.cols - 1):
			for row in range(start_row, end_row):
				var src = self.get_led_at(col + 1, row)
				self.get_led_at(col, row).copy(src)

	# copy 1st col to last one (right to left) or first one
	if left_to_right:
		col = 0
	else:
		col = self.cols - 1

	for row in range(start_row, end_row):
		self.get_led_at(col, row).set_color_with_alpha(buffer[row])
