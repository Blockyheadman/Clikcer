extends Control

func _ready():
	pass

func _process(_delta):
	$ClikcsCounter.text = "Clikcs: " + str(Global.clikcs)
	
	$Upgrade1Label.text = "Costs " + str(Global.upgrade1Cost) + " Clikcs"
	$Upgrade2Label.text = "Costs " + str(Global.upgrade2Cost) + " Clikcs"
	$Upgrade3Label.text = "Costs " + str(Global.upgrade3Cost) + " Clikcs"
	$Upgrade4Label.text = "Costs " + str(Global.upgrade4Cost) + " Clikcs"
	$Upgrade5Label.text = "Costs " + str(Global.upgrade5Cost) + " Clikcs"
	
	$Upgrade1Count.text = "You own: " + str(Global.upgrade1Count)
	$Upgrade2Count.text = "You own: " + str(Global.upgrade2Count)
	$Upgrade3Count.text = "You own: " + str(Global.upgrade3Count)
	$Upgrade4Count.text = "You own: " + str(Global.upgrade4Count)
	$Upgrade5Count.text = "You own: " + str(Global.upgrade5Count)
	

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
	print("saved game.")

func _on_ToHome_pressed():
	$ClikcerSFX.play(0)
	#get_tree().change_scene("res://scenes/Home.tscn")
	Global.transition_scene_top("Upgrades", "res://scenes/Home.tscn", .5, Tween.TRANS_SINE, Tween.EASE_OUT)

func _on_ToHome_mouse_entered():
	$AnimationPlayer.play("ToHomeHover")

func _on_ToHome_mouse_exited():
	$AnimationPlayer.play("ToHomeNormal")

func _on_ToHome_focus_exited():
	$AnimationPlayer.play("ToHomeNormal")

# hovers on labels

func _on_Upgrade1Label_mouse_entered():
	$LearnMoreLabel.text = "Adds 1 Clikcs to every click."

func _on_Upgrade1Label_mouse_exited():
	$LearnMoreLabel.text = "Hover or tap cost text to learn more."

func _on_Upgrade2Label_mouse_entered():
	$LearnMoreLabel.text = "Adds 10 Clikcs to every click."

func _on_Upgrade2Label_mouse_exited():
	$LearnMoreLabel.text = "Hover or tap cost text to learn more."

func _on_Upgrade3Label_mouse_entered():
	$LearnMoreLabel.text = "Adds 25 Clikcs to every click."

func _on_Upgrade3Label_mouse_exited():
	$LearnMoreLabel.text = "Hover or tap cost text to learn more."

func _on_Upgrade4Label_mouse_entered():
	$LearnMoreLabel.text = "Adds 50 Clikcs to every click."

func _on_Upgrade4Label_mouse_exited():
	$LearnMoreLabel.text = "Hover or tap cost text to learn more."

func _on_Upgrade5Label_mouse_entered():
	$LearnMoreLabel.text = "Adds 100 Clikcs to every click."

func _on_Upgrade5Label_mouse_exited():
	$LearnMoreLabel.text = "Hover or tap cost text to learn more."

# upgrade button actions
func _on_Upgrade1Button_pressed():
	$ClikcerSFX.play(0)
	if Global.clikcs >= Global.upgrade1Cost:
		Global.clikcs = Global.clikcs - Global.upgrade1Cost
		Global.upgrade1Count = Global.upgrade1Count + 1
		Global.upgrade1Cost = Global.upgrade1Cost + 15
		save_game()
	elif Global.clikcs < Global.upgrade1Cost:
		OS.alert("You need " + str(Global.upgrade1Cost - Global.clikcs) + " more Clikcs to get this upgrade!")

func _on_Upgrade2Button_pressed():
	$ClikcerSFX.play(0)
	if Global.clikcs >= Global.upgrade2Cost:
		Global.clikcs = Global.clikcs - Global.upgrade2Cost
		Global.upgrade2Count = Global.upgrade2Count + 1
		Global.upgrade2Cost = Global.upgrade2Cost + 125
		save_game()
	elif Global.clikcs < Global.upgrade2Cost:
		OS.alert("You need " + str(Global.upgrade2Cost - Global.clikcs) + " more Clikcs to get this upgrade!")

func _on_Upgrade3Button_pressed():
	$ClikcerSFX.play(0)
	if Global.clikcs >= Global.upgrade3Cost:
		Global.clikcs = Global.clikcs - Global.upgrade3Cost
		Global.upgrade3Count = Global.upgrade3Count + 1
		Global.upgrade3Cost = Global.upgrade3Cost + 725
		save_game()
	elif Global.clikcs < Global.upgrade3Cost:
		OS.alert("You need " + str(Global.upgrade3Cost - Global.clikcs) + " more Clikcs to get this upgrade!")

func _on_Upgrade4Button_pressed():
	$ClikcerSFX.play(0)
	if Global.clikcs >= Global.upgrade4Cost:
		Global.clikcs = Global.clikcs - Global.upgrade4Cost
		Global.upgrade4Count = Global.upgrade4Count + 1
		Global.upgrade4Cost = Global.upgrade4Cost + 1400
		save_game()
	elif Global.clikcs < Global.upgrade4Cost:
		OS.alert("You need " + str(Global.upgrade4Cost - Global.clikcs) + " more Clikcs to get this upgrade!")

func _on_Upgrade5Button_pressed():
	$ClikcerSFX.play(0)
	if Global.clikcs >= Global.upgrade5Cost:
		Global.clikcs = Global.clikcs - Global.upgrade5Cost
		Global.upgrade5Count = Global.upgrade5Count + 1
		Global.upgrade5Cost = Global.upgrade5Cost + 14250
		save_game()
	elif Global.clikcs < Global.upgrade5Cost:
		OS.alert("You need " + str(Global.upgrade5Cost - Global.clikcs) + " more Clikcs to get this upgrade!")

func _input(event):
	if event is InputEventScreenDrag:
		print(event.relative)
		if event.relative.y >= 35 and !Global.disableSwipe:# and event.index == 1:
			Global.transition_scene_top("Upgrades", "res://scenes/Home.tscn", .5, Tween.TRANS_SINE, Tween.EASE_OUT)
