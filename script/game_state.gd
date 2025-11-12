extends Node

signal data_changed(key: String, value: Variant)

# Enum for upgrade types
enum UpgradeType { FIRST_UPGRADE }

# Data structure
var data: Dictionary = {
	"pages": 0,
	"upgrades": {
		UpgradeType.FIRST_UPGRADE: {
			"click_multiplier": 1,
			"price": 10
		}
	}
}

func save() -> void:
	var file: FileAccess = FileAccess.open("user://save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load() -> void:
	if FileAccess.file_exists("user://save.json"):
		var file: FileAccess = FileAccess.open("user://save.json", FileAccess.READ)
		var result: Variant = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(result) == TYPE_DICTIONARY:
			data.merge(result, true)

	if not data.has("pages"):
		data["pages"] = 0
	if not data.has("upgrades"):
		data["upgrades"] = {
			UpgradeType.FIRST_UPGRADE: {"click_multiplier": 1, "price": 10}
		}

# --- Helper Functions ---

func get_value(key: String, default_value: Variant = null) -> Variant:
	return data.get(key, default_value)

func set_value(key: String, value: Variant, auto_save: bool = true) -> void:
	data[key] = value
	emit_signal("data_changed", key, value)
	if auto_save:
		save()

func add_pages(amount: int = 1, auto_save: bool = true) -> void:
	data["pages"] += amount
	emit_signal("data_changed", "pages", data["pages"])
	if auto_save:
		save()

func spend_pages(amount: int, auto_save: bool = true) -> bool:
	if data["pages"] >= amount:
		data["pages"] -= amount
		emit_signal("data_changed", "pages", data["pages"])
		if auto_save:
			save()
		return true
	return false

func update_upgrade(upgrade_type: int, click_inc: int = 1, price_mult: float = 1.5, auto_save: bool = true) -> void:
	var u: Dictionary = data["upgrades"].get(upgrade_type, {"click_multiplier": 1, "price": 10})
	u["click_multiplier"] += click_inc
	u["price"] = int(u["price"] * price_mult)
	data["upgrades"][upgrade_type] = u
	emit_signal("data_changed", "upgrades", data["upgrades"])
	if auto_save:
		save()

func get_upgrade(upgrade_type: int) -> Dictionary:
	# Returns the upgrade dictionary for the given type, with default fallback
	var upgrades: Dictionary = data.get("upgrades", {})
	if not upgrades.has(upgrade_type):
		upgrades[upgrade_type] = {"click_multiplier": 1, "price": 10}
	return upgrades[upgrade_type]
