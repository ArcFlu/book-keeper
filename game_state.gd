extends Node

var data := {
	"pages": 0,
	"first_upgrade": {
		"click_multiplier": 1,
		"price": 10
	}
}

func save() -> void:
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load() -> void:
	var default_data := {
		"pages": 0,
		"first_upgrade": {
			"click_multiplier": 1,
			"price": 10
		}
	}

	if FileAccess.file_exists("user://save.json"):
		var file = FileAccess.open("user://save.json", FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY:
			data = result

	# Ensure all keys exist
	_merge_dicts(default_data, data)

# Helper function: recursively merge default keys into loaded data
func _merge_dicts(default_dict: Dictionary, target_dict: Dictionary) -> void:
	for key in default_dict.keys():
		if not target_dict.has(key):
			target_dict[key] = default_dict[key]
		elif typeof(default_dict[key]) == TYPE_DICTIONARY:
			# Recurse for nested dictionaries
			if typeof(target_dict[key]) != TYPE_DICTIONARY:
				target_dict[key] = default_dict[key]
			else:
				_merge_dicts(default_dict[key], target_dict[key])
