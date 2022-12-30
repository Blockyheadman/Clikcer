extends Node

var AcceptDisabled := false

func _ready():
	OS.min_window_size = Vector2(490, 685)
	load_game()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://user.save"):
		save_game()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open_encrypted_with_pass("user://user.save", File.READ, "C53194F1C667972AFB7B05C5FF9462BAA6D349D2736A7659477CB8DC6BD97A07")
	#save_game.open("user://user.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		print("Success! 'clikcs' Value exists!")
		Global.clikcs = node_data["clikcs"]
		Global.upgrade1Count = node_data["upgrade1count"]
		Global.upgrade2Count = node_data["upgrade2count"]
		Global.upgrade3Count = node_data["upgrade3count"]
		Global.upgrade4Count = node_data["upgrade4count"]
		Global.upgrade5Count = node_data["upgrade5count"]
		Global.upgrade1Cost = node_data["upgrade1cost"]
		Global.upgrade2Cost = node_data["upgrade2cost"]
		Global.upgrade3Cost = node_data["upgrade3cost"]
		Global.upgrade4Cost = node_data["upgrade4cost"]
		Global.upgrade5Cost = node_data["upgrade5cost"]
		Global.achievement1 = node_data["achievement1"]
		Global.achievement2 = node_data["achievement2"]
		Global.achievement3 = node_data["achievement3"]
		Global.achievement4 = node_data["achievement4"]
		Global.achievement5 = node_data["achievement5"]
		Global.achievement1Claimed = node_data["achievement1claimed"]
		Global.achievement2Claimed = node_data["achievement2claimed"]
		Global.achievement3Claimed = node_data["achievement3claimed"]
		Global.achievement4Claimed = node_data["achievement4claimed"]
		Global.achievement5Claimed = node_data["achievement5claimed"]
		Global.AutoSaveEnabled = node_data["autosaveenabled"]
		Global.AutoSaveSliderValue = node_data["autosavetimeout"]
		if Global.isGuest == false:
			Global.username = node_data["username"]
			if Global.username == "":
				$UsernameInput.popup_centered()
			if Global.username != "":
				get_tree().change_scene("res://scenes/Home.tscn")
		elif Global.isGuest == true:
			Global.username = node_data["username"]
			if Global.username == "":
				$UsernameInput.popup_centered()
			if Global.username != "":
				get_tree().change_scene("res://scenes/Home.tscn")

	save_game.close()

func save():
	var save_dict = {
		"clikcs" : Global.clikcs,
		"upgrade1count" : Global.upgrade1Count,
		"upgrade2count" : Global.upgrade2Count,
		"upgrade3count" : Global.upgrade3Count,
		"upgrade4count" : Global.upgrade4Count,
		"upgrade5count" : Global.upgrade5Count,
		"upgrade1cost" : Global.upgrade1Cost,
		"upgrade2cost" : Global.upgrade2Cost,
		"upgrade3cost" : Global.upgrade3Cost,
		"upgrade4cost" : Global.upgrade4Cost,
		"upgrade5cost" : Global.upgrade5Cost,
		"achievement1" : Global.achievement1,
		"achievement2" : Global.achievement2,
		"achievement3" : Global.achievement3,
		"achievement4" : Global.achievement4,
		"achievement5" : Global.achievement5,
		"achievement1claimed" : Global.achievement1Claimed,
		"achievement2claimed" : Global.achievement2Claimed,
		"achievement3claimed" : Global.achievement3Claimed,
		"achievement4claimed" : Global.achievement4Claimed,
		"achievement5claimed" : Global.achievement5Claimed,
		"autosaveenabled" : Global.AutoSaveEnabled,
		"autosavetimeout" : Global.AutoSaveSliderValue,
		"username" : Global.username
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass("user://user.save", File.WRITE, "C53194F1C667972AFB7B05C5FF9462BAA6D349D2736A7659477CB8DC6BD97A07")
	#save_game.open("user://user.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func save_and_load_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass("user://user.save", File.WRITE, "C53194F1C667972AFB7B05C5FF9462BAA6D349D2736A7659477CB8DC6BD97A07")
	#save_game.open("user://user.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
	
	load_game()

func _on_LineEdit_text_changed(new_text):
	if $UsernameInput/LineEdit.text != "":
		AcceptDisabled = false
	else:
		AcceptDisabled = true
	
	$UsernameInput/AcceptButton.disabled = AcceptDisabled

func _on_AcceptButton_pressed():
	Global.username = $UsernameInput/LineEdit.get_text()
	save_and_load_game()
