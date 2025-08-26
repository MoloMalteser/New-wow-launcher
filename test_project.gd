extends Node

# Simple test script to verify the Godot WoW Launcher project
# This can be run to test basic functionality

func _ready():
	print("=== Godot WoW Launcher Test ===")
	
	# Test 1: Check if all required files exist
	test_file_structure()
	
	# Test 2: Test configuration loading
	test_config_loading()
	
	# Test 3: Test mobile detection
	test_mobile_detection()
	
	# Test 4: Test basic UI functionality
	test_ui_functionality()
	
	print("=== Test Complete ===")

func test_file_structure():
	print("\n1. Testing file structure...")
	
	var required_files = [
		"res://project.godot",
		"res://config.json",
		"res://scenes/Main.tscn",
		"res://scripts/LauncherManager.gd",
		"res://scripts/MainUI.gd",
		"res://scripts/TouchJoystick.gd",
		"res://scripts/MobileSettings.gd"
	]
	
	var all_files_exist = true
	for file_path in required_files:
		if FileAccess.file_exists(file_path):
			print("✓ Found: " + file_path)
		else:
			print("✗ Missing: " + file_path)
			all_files_exist = false
	
	if all_files_exist:
		print("✓ All required files found!")
	else:
		print("✗ Some files are missing!")

func test_config_loading():
	print("\n2. Testing configuration loading...")
	
	var config_file = FileAccess.open("res://config.json", FileAccess.READ)
	if config_file:
		var json_string = config_file.get_as_text()
		var config = JSON.parse_string(json_string)
		config_file.close()
		
		if config:
			print("✓ Configuration loaded successfully")
			print("  - Host: " + str(config.get("host", "Not found")))
			print("  - Default Language: " + str(config.get("default_language", "Not found")))
			print("  - Mobile Settings: " + str(config.has("mobile_settings")))
		else:
			print("✗ Failed to parse configuration JSON")
	else:
		print("✗ Could not open configuration file")

func test_mobile_detection():
	print("\n3. Testing mobile detection...")
	
	var is_mobile = OS.has_feature("mobile")
	print("  - Mobile platform: " + str(is_mobile))
	
	if is_mobile:
		var screen_size = DisplayServer.screen_get_size()
		print("  - Screen size: " + str(screen_size))
		
		# Test mobile settings
		var mobile_settings = MobileSettings.new()
		add_child(mobile_settings)
		mobile_settings.optimize_for_device()
		print("  - Device type: " + mobile_settings.get_device_type())
		print("  - Optimal button size: " + str(mobile_settings.get_optimal_button_size()))
		print("  - Optimal joystick size: " + str(mobile_settings.get_optimal_joystick_size()))
		mobile_settings.queue_free()
	else:
		print("  - Running on desktop platform")

func test_ui_functionality():
	print("\n4. Testing UI functionality...")
	
	# Test launcher manager creation
	var launcher_manager = LauncherManager.new()
	add_child(launcher_manager)
	
	# Test basic properties
	print("  - Launcher manager created: " + str(launcher_manager != null))
	print("  - Download in progress: " + str(launcher_manager.is_download_in_progress()))
	print("  - Download progress: " + str(launcher_manager.get_download_progress()))
	
	# Test joystick creation (if on mobile)
	if OS.has_feature("mobile"):
		var joystick = TouchJoystick.new()
		add_child(joystick)
		print("  - Touch joystick created: " + str(joystick != null))
		joystick.queue_free()
	
	launcher_manager.queue_free()

func _input(event):
	# Exit test on any key press
	if event is InputEventKey and event.pressed:
		get_tree().quit()