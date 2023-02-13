extends Control

# make a way to show save file OS.shell_open()

func _ready():
	$AutoSaveSwitch.pressed = Global.AutoSaveEnabled
	$AutoSaveSlider.value = Global.AutoSaveSliderValue
	Firebase.Auth.connect("logged_out", self, "signed_out")
	if Global.isGuest == true:
		$SignOut.text = "To Login"

func _on_ToHome_pressed():
	$ClikcerSFX.play(0)
	get_tree().change_scene("res://scenes/Home.tscn")

func _on_ToHome_mouse_entered():
	$AnimationPlayer.play("ToHomeHover")

func _on_ToHome_mouse_exited():
	$AnimationPlayer.play("ToHomeNormal")

func _on_ToHome_focus_exited():
	$AnimationPlayer.play("ToHomeNormal")

func _on_AutoSaveSlider_value_changed(value):
	Global.AutoSaveSliderValue = value
	print("value = " + str(Global.AutoSaveSliderValue))
	save_game()

func _on_AutoSaveSwitch_pressed():
	Global.AutoSaveEnabled = !Global.AutoSaveEnabled
	$ClikcerSFX.play(0)
	save_game()

func _on_EraseSaveData_pressed():
	$EraseDataWarning.popup_centered()
	$ClikcerSFX.play(0)

func _on_EraseDataWarning_confirmed():
	Global.clikcs = 0
	Global.upgrade1Count = 1
	Global.upgrade2Count = 0
	Global.upgrade3Count = 0
	Global.upgrade4Count = 0
	Global.upgrade5Count = 0
	Global.upgrade1Cost = 300
	Global.upgrade2Cost = 2500
	Global.upgrade3Cost = 14500
	Global.upgrade4Cost = 28000
	Global.upgrade5Cost = 285000
	Global.achievement1 = false
	Global.achievement2 = false
	Global.achievement3 = false
	Global.achievement4 = false
	Global.achievement5 = false
	Global.achievement1Claimed = false
	Global.achievement2Claimed = false
	Global.achievement3Claimed = false
	Global.achievement4Claimed = false
	Global.achievement5Claimed = false
	Global.username = Global.username
	get_tree().change_scene("res://scenes/Reset.tscn")

func save():
	var save_dict = {
		"clikcs" : Global.clikcs,
		"upgrade1count" : Global.upgrade1Count,
		"upgrade2count" : Global.upgrade2Count,
		"upgrade3count" : Global.upgrade3Count,
		"upgrade4count" : Global.upgrade4Count,
		"upgrade5count" : Global.upgrade5Count,
		"upgrade1cost" : Global.upgrade1Cost,
		"upgrade2cost" : Global.upgrade1Cost,
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

func _on_AutoSaveTimeoutLabel_mouse_entered():
	$LearnMoreLabel.text = "Change the amount of time (in seconds) for it to autosave."

func _on_AutoSaveTimeoutLabel_mouse_exited():
	$LearnMoreLabel.text = "Hover or tap option text to learn more."

func _on_AutoSaveLabel_mouse_entered():
	$LearnMoreLabel.text = "Enables or disables autosave"

func _on_AutoSaveLabel_mouse_exited():
	$LearnMoreLabel.text = "Hover or tap option text to learn more."

func _on_SignOut_pressed():
	if Global.isGuest == false:
		Firebase.Auth.logout()
	if Global.isGuest == true:
		get_tree().change_scene("res://scenes/Login.tscn")

func signed_out():
	get_tree().change_scene("res://scenes/Login.tscn")
