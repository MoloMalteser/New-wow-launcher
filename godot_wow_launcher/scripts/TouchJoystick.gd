extends Control
class_name TouchJoystick

signal joystick_moved(direction: Vector2)
signal joystick_released

@export var joystick_size: float = 100.0
@export var deadzone: float = 10.0
@export var max_distance: float = 50.0

var joystick_center: Vector2
var joystick_position: Vector2
var is_dragging: bool = false
var touch_id: int = -1

# Visual elements
var background_circle: ColorRect
var joystick_knob: ColorRect

func _ready():
	# Create visual elements
	background_circle = ColorRect.new()
	background_circle.color = Color(0.2, 0.2, 0.2, 0.5)
	background_circle.size = Vector2(joystick_size, joystick_size)
	background_circle.position = Vector2(-joystick_size/2, -joystick_size/2)
	add_child(background_circle)
	
	joystick_knob = ColorRect.new()
	joystick_knob.color = Color(0.8, 0.8, 0.8, 0.8)
	joystick_knob.size = Vector2(joystick_size/3, joystick_size/3)
	joystick_knob.position = Vector2(-joystick_size/6, -joystick_size/6)
	add_child(joystick_knob)
	
	# Set up the control
	custom_minimum_size = Vector2(joystick_size, joystick_size)
	size = Vector2(joystick_size, joystick_size)
	
	# Center the joystick
	joystick_center = size / 2
	joystick_position = joystick_center
	
	# Make it visible on mobile
	if OS.has_feature("mobile"):
		show()
	else:
		hide()

func _input(event):
	if not OS.has_feature("mobile"):
		return
	
	if event is InputEventScreenTouch:
		if event.pressed and not is_dragging:
			# Check if touch is within joystick area
			var local_pos = get_local_mouse_position()
			if (local_pos - joystick_center).length() <= joystick_size/2:
				touch_id = event.index
				is_dragging = true
				_handle_joystick_input(local_pos)
		elif not event.pressed and event.index == touch_id:
			# Release joystick
			is_dragging = false
			touch_id = -1
			_reset_joystick()
			joystick_released.emit()
	
	elif event is InputEventScreenDrag and is_dragging and event.index == touch_id:
		_handle_joystick_input(get_local_mouse_position())

func _handle_joystick_input(input_position: Vector2):
	var direction = input_position - joystick_center
	var distance = direction.length()
	
	# Apply deadzone
	if distance < deadzone:
		direction = Vector2.ZERO
		joystick_position = joystick_center
	else:
		# Limit to max distance
		if distance > max_distance:
			direction = direction.normalized() * max_distance
		
		joystick_position = joystick_center + direction
	
	# Update visual position
	joystick_knob.position = joystick_position - joystick_knob.size/2
	
	# Emit signal with normalized direction
	var normalized_direction = Vector2.ZERO
	if distance > deadzone:
		normalized_direction = direction.normalized()
	
	joystick_moved.emit(normalized_direction)

func _reset_joystick():
	joystick_position = joystick_center
	joystick_knob.position = joystick_center - joystick_knob.size/2
	joystick_moved.emit(Vector2.ZERO)

func _draw():
	# Draw joystick background circle
	draw_circle(joystick_center, joystick_size/2, Color(0.2, 0.2, 0.2, 0.3))
	
	# Draw joystick knob
	draw_circle(joystick_position, joystick_size/6, Color(0.8, 0.8, 0.8, 0.8))

func set_joystick_size(new_size: float):
	joystick_size = new_size
	custom_minimum_size = Vector2(joystick_size, joystick_size)
	size = Vector2(joystick_size, joystick_size)
	joystick_center = size / 2
	max_distance = joystick_size / 2
	
	# Update visual elements
	background_circle.size = Vector2(joystick_size, joystick_size)
	background_circle.position = Vector2(-joystick_size/2, -joystick_size/2)
	
	joystick_knob.size = Vector2(joystick_size/3, joystick_size/3)
	joystick_knob.position = Vector2(-joystick_size/6, -joystick_size/6)
	
	queue_redraw()