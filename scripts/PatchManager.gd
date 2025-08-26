extends RefCounted

# Patch Manager für WoW Launcher
# Verwaltet Downloads, Patches und Addons

# Patch Daten
var patch_list = []
var selected_patches = []
var selected_addons = []
var download_in_progress = false

# Konfiguration
var config = {}
var dir_data = ""

func _init():
	load_config()
	load_patches()

func load_config():
	# Lade Konfiguration
	var config_file = FileAccess.open("res://config.json", FileAccess.READ)
	if config_file:
		var json_string = config_file.get_as_text()
		config = JSON.parse_string(json_string)
		config_file.close()

func load_patches():
	# Lade Patch-Liste
	# In der echten Implementierung würde hier die Patch-Liste vom Server geladen
	patch_list = [
		{
			"name": "Core Game Files",
			"version": "1.0.0",
			"size": 1024,
			"mandatory": true,
			"selected": true
		},
		{
			"name": "Latest Patch",
			"version": "1.0.1",
			"size": 512,
			"mandatory": false,
			"selected": true
		}
	]
	
	selected_patches = find_selected_patches()

func find_selected_patches():
	# Finde ausgewählte Patches
	var selected = []
	for patch in patch_list:
		if patch.get("selected", false) or patch.get("mandatory", false):
			selected.append(patch)
	return selected

func find_selected_addons():
	# Finde ausgewählte Addons
	# In der echten Implementierung würde hier die Addon-Liste geladen
	selected_addons = []
	return selected_addons

func generate_download_files():
	# Generiere Download-Liste für Dateien
	var download_list = {}
	
	for patch in selected_patches:
		download_list[patch.name] = {
			"sourcePath": "patches/" + patch.name + ".zip",
			"targetPath": "data/" + patch.name + ".zip",
			"md5": "dummy_md5_hash"
		}
	
	return download_list

func generate_download_addons():
	# Generiere Download-Liste für Addons
	var download_list = {}
	
	for addon in selected_addons:
		download_list[addon.name] = {
			"sourcePath": "addons/" + addon.name + ".zip",
			"targetPath": "addons/" + addon.name + ".zip",
			"unzipPath": "Interface/AddOns/",
			"directories": [addon.name]
		}
	
	return download_list

func generate_delete_files():
	# Generiere Liste zu löschender Dateien
	var delete_list = {}
	
	# Hier würden Dateien aufgelistet, die gelöscht werden sollen
	# z.B. alte Patch-Dateien
	
	return delete_list

func generate_delete_addons():
	# Generiere Liste zu löschender Addons
	var delete_list = []
	
	# Hier würden Addons aufgelistet, die gelöscht werden sollen
	
	return delete_list

func check_file_exists(file_path: String) -> bool:
	# Prüfe ob Datei existiert
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		file.close()
		return true
	return false

func calculate_file_md5(file_path: String) -> String:
	# Berechne MD5-Hash einer Datei
	# In der echten Implementierung würde hier MD5 berechnet
	return "dummy_md5_hash"

func download_file(source_path: String, target_path: String) -> bool:
	# Lade Datei herunter
	# In der echten Implementierung würde hier HTTP-Download stattfinden
	
	# Simuliere Download
	await get_tree().create_timer(1.0).timeout
	
	# Erstelle Dummy-Datei
	var file = FileAccess.open(target_path, FileAccess.WRITE)
	if file:
		file.store_string("Dummy file content")
		file.close()
		return true
	
	return false

func extract_zip(zip_path: String, extract_path: String) -> bool:
	# Entpacke ZIP-Datei
	# In der echten Implementierung würde hier ZIP-Extraktion stattfinden
	
	# Simuliere Extraktion
	await get_tree().create_timer(0.5).timeout
	
	# Erstelle Dummy-Verzeichnis
	var dir = DirAccess.open("res://")
	if dir:
		dir.make_dir_recursive(extract_path)
		return true
	
	return false

func delete_file(file_path: String) -> bool:
	# Lösche Datei
	var dir = DirAccess.open("res://")
	if dir:
		return dir.remove(file_path) == OK
	return false

func delete_directory(dir_path: String) -> bool:
	# Lösche Verzeichnis
	var dir = DirAccess.open("res://")
	if dir:
		return dir.remove_recursive(dir_path) == OK
	return false

# Event Bus Integration
signal download_progress(percent: float)
signal file_download_progress(percent: float)
signal download_complete()
signal download_error(error: String)

func emit_download_progress(percent: float):
	download_progress.emit(percent)

func emit_file_download_progress(percent: float):
	file_download_progress.emit(percent)

func emit_download_complete():
	download_complete.emit()

func emit_download_error(error: String):
	download_error.emit(error)