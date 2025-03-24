extends Node

class_name Level

## A class for levels that gives them access to these universal functions

var level_name: String = ""


func get_collected_coins(coin_container: Node) -> Array:
	var collected_names = []
	for coin in coin_container.get_children():
		if coin.is_in_group("collected"):
			collected_names.append(coin.name)
	return collected_names



func setup_level(coin_container: Node) -> void:
	print("Setting up level...")
	# Step 1: Get current scene name
	if level_name == "":
		push_warning("Level name not set — setup_level skipped.")
		return
	print("Level name: ", level_name)
	
	# Step 2: Load level data
	var data = SceneManager.load_level_data()
	var levels = data.get("levels", [])
	
	# Step 3: Find the matching level entry
	for level in levels:
		if level.get("level_name") == level_name:
			print("Level found in save file...")
			var collected = level.get("collected_coins", [])
			print("These coins collected according to save file: ", collected)
			
			# Step 4: Despawn coins that are already collected
			for coin in coin_container.get_children():
				if coin.name in collected:
					print("Removing ", coin)
					coin.queue_free()
					
			print("Level setup complete for:", level_name)
			return  # Early exit once level is found
