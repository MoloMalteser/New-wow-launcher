extends Node
class_name MobileSettings

signal settings_changed(setting_name: String, new_value)

# Mobile-specific settings
var joystick_size: float = 100.0
var joystick_deadzone: float = 10.0
var button_size: float = 80.0
var enable_vibration: bool = true
var enable_sound_feedback: bool = true
var enable_gestures: bool = true
var auto_rotate: bool = true

# Gesture settings
var swipe_threshold: float = 50.0
var long_press_duration: float = 0.5
var double_tap_duration: float = 0.3

# Performance settings
var target_fps: int = 60
var enable_particle_effects: bool = true
var enable_shadows: bool = false
var texture_quality: String = "medium"  # low, medium, high

func _ready():
	load_mobile_settings()

func load_mobile_settings():
	var config_file = FileAccess.open("config.json", FileAccess.READ)
	if config_file:
		var json_string = config_file.get_as_text()
		var config = JSON.parse_string(json_string)
		config_file.close()
		
		if config and config.has("mobile_settings"):
			var mobile_config = config.mobile_settings
			joystick_size = mobile_config.get("joystick_size", 100.0)
			joystick_deadzone = mobile_config.get("joystick_deadzone", 10.0)
			button_size = mobile_config.get("button_size", 80.0)
			enable_vibration = mobile_config.get("enable_vibration", true)
			enable_sound_feedback = mobile_config.get("enable_sound_feedback", true)
			
			# Apply settings
			_apply_mobile_settings()

func save_mobile_settings():
	var config_file = FileAccess.open("config.json", FileAccess.READ)
	var config = {}
	if config_file:
		var json_string = config_file.get_as_text()
		config = JSON.parse_string(json_string)
		config_file.close()
	
	# Update mobile settings
	config.mobile_settings = {
		"joystick_size": joystick_size,
		"joystick_deadzone": joystick_deadzone,
		"button_size": button_size,
		"enable_vibration": enable_vibration,
		"enable_sound_feedback": enable_sound_feedback
	}
	
	# Save back to file
	var save_file = FileAccess.open("config.json", FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(config, "\t"))
		save_file.close()

func _apply_mobile_settings():
	# Apply joystick settings
	if has_node("/root/Main/MobileControls/Joystick"):
		var joystick = get_node("/root/Main/MobileControls/Joystick")
		joystick.joystick_size = joystick_size
		joystick.deadzone = joystick_deadzone
		joystick.max_distance = joystick_size / 2
	
	# Apply performance settings
	Engine.target_fps = target_fps
	
	# Apply rendering settings
	var viewport = get_viewport()
	if viewport:
		viewport.msaa = Viewport.MSAA_4X if texture_quality == "high" else Viewport.MSAA_DISABLED

func set_joystick_size(size: float):
	joystick_size = size
	_apply_mobile_settings()
	settings_changed.emit("joystick_size", size)

func set_joystick_deadzone(deadzone: float):
	joystick_deadzone = deadzone
	_apply_mobile_settings()
	settings_changed.emit("joystick_deadzone", deadzone)

func set_button_size(size: float):
	button_size = size
	settings_changed.emit("button_size", size)

func set_vibration_enabled(enabled: bool):
	enable_vibration = enabled
	settings_changed.emit("enable_vibration", enabled)

func set_sound_feedback_enabled(enabled: bool):
	enable_sound_feedback = enabled
	settings_changed.emit("enable_sound_feedback", enabled)

func vibrate(duration: float = 0.1):
	if enable_vibration and OS.has_feature("mobile"):
		# Use Input.vibrate_handheld() for mobile vibration
		Input.vibrate_handheld(duration)

func play_sound_feedback(sound_name: String):
	if enable_sound_feedback:
		# Play a short feedback sound
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		
		# Load and play the sound
		var sound_file = "res://assets/sounds/" + sound_name + ".wav"
		if FileAccess.file_exists(sound_file):
			var audio_stream = AudioStreamWAV.new()
			var file = FileAccess.open(sound_file, FileAccess.READ)
			if file:
				audio_stream.data = file.get_buffer(file.get_length())
				file.close()
				audio_player.stream = audio_stream
				audio_player.play()
				
				# Remove player after sound finishes
				audio_player.finished.connect(func(): audio_player.queue_free())

func get_optimal_button_size() -> float:
	# Calculate optimal button size based on screen size
	var screen_size = DisplayServer.screen_get_size()
	var min_dimension = min(screen_size.x, screen_size.y)
	return min_dimension * 0.15  # 15% of screen size

func get_optimal_joystick_size() -> float:
	# Calculate optimal joystick size based on screen size
	var screen_size = DisplayServer.screen_get_size()
	var min_dimension = min(screen_size.x, screen_size.y)
	return min_dimension * 0.2  # 20% of screen size

func is_tablet() -> bool:
	# Detect if device is a tablet
	var screen_size = DisplayServer.screen_get_size()
	var aspect_ratio = screen_size.x / screen_size.y
	return aspect_ratio >= 0.7 and aspect_ratio <= 1.3

func get_device_type() -> String:
	if is_tablet():
		return "tablet"
	else:
		return "phone"

func optimize_for_device():
	# Automatically optimize settings based on device type
	var device_type = get_device_type()
	
	if device_type == "tablet":
		button_size = get_optimal_button_size()
		joystick_size = get_optimal_joystick_size()
		enable_shadows = true
		texture_quality = "high"
	else:
		button_size = get_optimal_button_size()
		joystick_size = get_optimal_joystick_size()
		enable_shadows = false
		texture_quality = "medium"
	
	_apply_mobile_settings()