extends Node
class_name LauncherManager

signal download_progress(progress: float, current_file: String, total_files: int)
signal download_complete()
signal download_error(error_message: String)
signal patch_check_complete(patches: Array)
signal game_launched()

# Configuration
var config: Dictionary = {
	"host": "ftp.murlocvillage.com",
	"available_language": ["frFR", "enUS"],
	"default_language": "enUS",
	"patchlist_endpoint": "https://wotlk.murlocvillage.com/api/launcher",
	"end_sound": "murloc.mp3",
	"extension": true
}

# Download state
var is_downloading: bool = false
var current_downloads: Array[Dictionary] = []
var downloaded_files: Array[String] = []
var total_files: int = 0
var current_file_index: int = 0

# HTTP client for downloads
var http_client: HTTPRequest
var ftp_client: HTTPRequest

# File system
var game_directory: String = ""
var data_directory: String = ""

func _ready():
	http_client = HTTPRequest.new()
	ftp_client = HTTPRequest.new()
	add_child(http_client)
	add_child(ftp_client)
	
	http_client.request_completed.connect(_on_http_request_completed)
	ftp_client.request_completed.connect(_on_ftp_request_completed)
	
	# Set up game directory
	game_directory = OS.get_executable_path().get_base_dir()
	data_directory = game_directory.path_join("Data")
	
	# Create directories if they don't exist
	DirAccess.make_dir_recursive_absolute(data_directory)

func load_config(config_path: String = "config.json"):
	var config_file = FileAccess.open(config_path, FileAccess.READ)
	if config_file:
		var json_string = config_file.get_as_text()
		config = JSON.parse_string(json_string)
		config_file.close()
		print("Configuration loaded: ", config)

func save_config(config_path: String = "config.json"):
	var config_file = FileAccess.open(config_path, FileAccess.WRITE)
	if config_file:
		config_file.store_string(JSON.stringify(config))
		config_file.close()

func check_patches():
	print("Checking for patches...")
	var url = config.patchlist_endpoint
	if config.extension:
		url += ".json"
	
	http_client.request(url)

func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		download_error.emit("Failed to connect to patch server")
		return
	
	if response_code != 200:
		download_error.emit("Server returned error: " + str(response_code))
		return
	
	var json_string = body.get_string_from_utf8()
	var patches = JSON.parse_string(json_string)
	
	if patches:
		patch_check_complete.emit(patches)
		_process_patches(patches)
	else:
		download_error.emit("Invalid patch data received")

func _process_patches(patches: Dictionary):
	# Process delete files
	if patches.has("delete"):
		_process_delete_files(patches.delete)
	
	# Process mandatory files
	if patches.has("mandatory"):
		_process_mandatory_files(patches.mandatory)
	
	# Process optional files
	if patches.has("optional"):
		_process_optional_files(patches.optional)

func _process_delete_files(delete_files: Dictionary):
	for file_name in delete_files:
		var target_path = delete_files[file_name].targetPath
		var full_path = game_directory.path_join(target_path)
		
		if FileAccess.file_exists(full_path):
			DirAccess.remove_absolute(full_path)
			print("Deleted file: ", full_path)

func _process_mandatory_files(mandatory_files: Dictionary):
	current_downloads.clear()
	total_files = mandatory_files.size()
	current_file_index = 0
	
	for file_name in mandatory_files:
		var file_info = mandatory_files[file_name]
		current_downloads.append({
			"name": file_name,
			"source_path": file_info.sourcePath,
			"target_path": file_info.targetPath,
			"md5": file_info.md5
		})
	
	_start_downloads()

func _process_optional_files(optional_files: Array):
	# This would be handled by the UI to let user choose which optional files to download
	pass

func _start_downloads():
	if current_downloads.is_empty():
		download_complete.emit()
		return
	
	is_downloading = true
	_download_next_file()

func _download_next_file():
	if current_file_index >= current_downloads.size():
		is_downloading = false
		download_complete.emit()
		return
	
	var file_info = current_downloads[current_file_index]
	var source_url = "ftp://" + config.host + file_info.source_path
	var target_path = game_directory.path_join(file_info.target_path)
	
	# Create directory if it doesn't exist
	var target_dir = target_path.get_base_dir()
	DirAccess.make_dir_recursive_absolute(target_dir)
	
	# Start download
	ftp_client.download_file = target_path
	ftp_client.request(source_url)
	
	download_progress.emit(
		float(current_file_index) / float(total_files),
		file_info.name,
		total_files
	)

func _on_ftp_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		download_error.emit("Failed to download file")
		return
	
	# Verify MD5 if provided
	var file_info = current_downloads[current_file_index]
	if file_info.md5 != "":
		var target_path = game_directory.path_join(file_info.target_path)
		var calculated_md5 = _calculate_file_md5(target_path)
		if calculated_md5 != file_info.md5:
			download_error.emit("MD5 mismatch for file: " + file_info.name)
			return
	
	current_file_index += 1
	_download_next_file()

func _calculate_file_md5(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return ""
	
	var md5_context = HashingContext.new()
	md5_context.start(HashingContext.HASH_MD5)
	
	while not file.eof_reached():
		var chunk = file.get_buffer(4096)
		md5_context.update(chunk)
	
	file.close()
	return md5_context.finish().hex_encode()

func launch_game():
	var wow_exe = game_directory.path_join("Wow.exe")
	if FileAccess.file_exists(wow_exe):
		OS.execute(wow_exe, [], false)
		game_launched.emit()
	else:
		download_error.emit("WoW executable not found")

func get_download_progress() -> float:
	if total_files == 0:
		return 0.0
	return float(current_file_index) / float(total_files)

func get_current_file() -> String:
	if current_file_index < current_downloads.size():
		return current_downloads[current_file_index].name
	return ""

func is_download_in_progress() -> bool:
	return is_downloading

func cancel_download():
	is_downloading = false
	current_downloads.clear()
	current_file_index = 0
	total_files = 0