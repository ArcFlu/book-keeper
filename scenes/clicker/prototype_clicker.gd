class_name PrototypeClicker
extends Control

@export var label: Label

var game_state := {
	"pages": 0,
	"button_upgrade": 1
}

func _ready() -> void:
	load_game_state()
	update_label_text()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game_state()
	elif what == NOTIFICATION_PREDELETE:
		save_game_state()

func add_pages() -> void:
	game_state["pages"] += 1 * game_state["button_upgrade"]
	update_label_text()
	save_game_state()

func update_label_text() -> void:
	label.text = "Pages: %d" % game_state["pages"]

func save_game_state() -> void:
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(game_state))
		file.close()

func load_game_state() -> void:
	if FileAccess.file_exists("user://save.json"):
		var file = FileAccess.open("user://save.json", FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY:
			game_state = result

func _on_button_pressed() -> void:
	add_pages()
