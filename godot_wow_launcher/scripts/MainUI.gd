extends Control
class_name MainUI

# UI Elements
@onready var progress_bar: ProgressBar = $MainContainer/ProgressContainer/ProgressBar
@onready var status_label: Label = $MainContainer/StatusContainer/StatusLabel
@onready var current_file_label: Label = $MainContainer/StatusContainer/CurrentFileLabel
@onready var check_patches_button: Button = $MainContainer/ButtonContainer/CheckPatchesButton
@onready var launch_game_button: Button = $MainContainer/ButtonContainer/LaunchGameButton
@onready var cancel_button: Button = $MainContainer/ButtonContainer/CancelButton
@onready var settings_button: Button = $MainContainer/ButtonContainer/SettingsButton
@onready var mobile_controls: Control = $MobileControls
@onready var joystick: TouchJoystick = $MobileControls/Joystick
@onready var mobile_buttons: Control = $MobileControls/MobileButtons

# Launcher manager
var launcher_manager: LauncherManager

# Mobile UI state
var is_mobile: bool = false
var mobile_button_size: float = 80.0
var mobile_button_spacing: float = 20.0

func _ready():
	# Initialize launcher manager
	launcher_manager = LauncherManager.new()
	add_child(launcher_manager)
	
	# Connect signals
	launcher_manager.download_progress.connect(_on_download_progress)
	launcher_manager.download_complete.connect(_on_download_complete)
	launcher_manager.download_error.connect(_on_download_error)
	launcher_manager.patch_check_complete.connect(_on_patch_check_complete)
	launcher_manager.game_launched.connect(_on_game_launched)
	
	# Connect button signals
	check_patches_button.pressed.connect(_on_check_patches_pressed)
	launch_game_button.pressed.connect(_on_launch_game_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	
	# Setup mobile controls
	_setup_mobile_controls()
	
	# Load configuration
	launcher_manager.load_config()
	
	# Update UI state
	_update_ui_state()

func _setup_mobile_controls():
	is_mobile = OS.has_feature("mobile")
	
	if is_mobile:
		mobile_controls.show()
		_setup_mobile_buttons()
		_setup_joystick()
	else:
		mobile_controls.hide()

func _setup_mobile_buttons():
	# Create mobile-specific buttons
	var button_container = VBoxContainer.new()
	button_container.custom_minimum_size = Vector2(mobile_button_size, 200)
	
	# Check patches button
	var mobile_check_button = Button.new()
	mobile_check_button.text = "Check Patches"
	mobile_check_button.custom_minimum_size = Vector2(mobile_button_size, mobile_button_size)
	mobile_check_button.pressed.connect(_on_check_patches_pressed)
	button_container.add_child(mobile_check_button)
	
	# Launch game button
	var mobile_launch_button = Button.new()
	mobile_launch_button.text = "Launch Game"
	mobile_launch_button.custom_minimum_size = Vector2(mobile_button_size, mobile_button_size)
	mobile_launch_button.pressed.connect(_on_launch_game_pressed)
	button_container.add_child(mobile_launch_button)
	
	# Settings button
	var mobile_settings_button = Button.new()
	mobile_settings_button.text = "Settings"
	mobile_settings_button.custom_minimum_size = Vector2(mobile_button_size, mobile_button_size)
	mobile_settings_button.pressed.connect(_on_settings_pressed)
	button_container.add_child(mobile_settings_button)
	
	mobile_buttons.add_child(button_container)

func _setup_joystick():
	joystick.joystick_moved.connect(_on_joystick_moved)
	joystick.joystick_released.connect(_on_joystick_released)

func _on_joystick_moved(direction: Vector2):
	# Handle joystick input for navigation
	if direction.length() > 0.1:
		# You can use this for custom navigation or game control
		print("Joystick moved: ", direction)

func _on_joystick_released():
	print("Joystick released")

func _on_check_patches_pressed():
	status_label.text = "Checking for patches..."
	check_patches_button.disabled = true
	launcher_manager.check_patches()

func _on_launch_game_pressed():
	status_label.text = "Launching game..."
	launcher_manager.launch_game()

func _on_cancel_pressed():
	if launcher_manager.is_download_in_progress():
		launcher_manager.cancel_download()
		status_label.text = "Download cancelled"
		_update_ui_state()

func _on_settings_pressed():
	# Open settings dialog
	_show_settings_dialog()

func _on_download_progress(progress: float, current_file: String, total_files: int):
	progress_bar.value = progress * 100
	current_file_label.text = "Downloading: " + current_file
	status_label.text = "Downloading files... (" + str(int(progress * 100)) + "%)"

func _on_download_complete():
	progress_bar.value = 100
	status_label.text = "Download complete!"
	current_file_label.text = ""
	_update_ui_state()
	
	# Play completion sound if configured
	if launcher_manager.config.has("end_sound"):
		_play_completion_sound(launcher_manager.config.end_sound)

func _on_download_error(error_message: String):
	status_label.text = "Error: " + error_message
	current_file_label.text = ""
	_update_ui_state()

func _on_patch_check_complete(patches: Array):
	status_label.text = "Patch check complete"
	_update_ui_state()

func _on_game_launched():
	status_label.text = "Game launched successfully!"

func _update_ui_state():
	var is_downloading = launcher_manager.is_download_in_progress()
	
	check_patches_button.disabled = is_downloading
	launch_game_button.disabled = is_downloading
	cancel_button.visible = is_downloading
	
	# Update mobile buttons
	if is_mobile:
		for child in mobile_buttons.get_child(0).get_children():
			if child is Button:
				child.disabled = is_downloading

func _show_settings_dialog():
	# Create a simple settings dialog
	var dialog = AcceptDialog.new()
	dialog.title = "Settings"
	dialog.dialog_text = "Settings dialog - configure your launcher options here"
	dialog.add_cancel_button("Cancel")
	add_child(dialog)
	dialog.popup_centered()

func _play_completion_sound(sound_file: String):
	# Load and play completion sound
	var audio_stream = AudioStreamMP3.new()
	var file = FileAccess.open("res://assets/sounds/" + sound_file, FileAccess.READ)
	if file:
		audio_stream.data = file.get_buffer(file.get_length())
		file.close()
		
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.stream = audio_stream
		audio_player.play()
		
		# Remove player after sound finishes
		audio_player.finished.connect(func(): audio_player.queue_free())

func _input(event):
	# Handle mobile-specific input
	if is_mobile and event is InputEventScreenTouch:
		if event.pressed:
			# Handle touch input for mobile navigation
			pass