extends Control

var disableClikcerButton = false

func _ready():
	$ClikcsPerClickLabel.text = "You get " + str(Global.upgrade1Count + (Global.upgrade2Count*10) + (Global.upgrade3Count*25) + (Global.upgrade4Count*50) + (Global.upgrade5Count*100)) + " Clikcs per click."
	$ClikcsCounter.text = "Clikcs: " + str(Global.clikcs)
	$VersionLabel.text = "Ver: " + Global.gameVersion
	
	if Global.seenUpdateWarning == false:
		yield(get_tree().create_timer(1), "timeout")
		check_for_updates()
	
	if Global.AutoSaveEnabled == true:
		$AutoSaveTimer.start(0)
		$AutoSaveTimer.autostart = true
	if Global.AutoSaveEnabled == false:
		$AutoSaveTimer.autostart = false
	if Global.loginAvailable == true and Global.isGuest == true:
		$SignedInAs.text = "Guest Mode"
	elif Global.loginAvailable == true and Global.isGuest == false:
		$SignedInAs.text = "Signed In As: " + Global.username
	else:
		$SignedInAs.text = "Sign-In not available on this build"

func _process(_delta):
	$AutoSaveTimer.wait_time = Global.AutoSaveSliderValue

func _on_SettingsButton_mouse_entered():
	$AnimationPlayer.play("SettingsButtonHover")

func _on_SettingsButton_mouse_exited():
	$AnimationPlayer.play("SettingsButtonNormal")

func _on_SettingsButton_focus_exited():
	$AnimationPlayer.play("SettingsButtonNormal")

func _on_ClikcerButton_mouse_entered():
	$AnimationPlayer.play("ClikcerButtonHover")

func _on_ClikcerButton_mouse_exited():
	$AnimationPlayer.play("ClikcerButtonNormal")

func _on_ClikcerButton_focus_exited():
	$AnimationPlayer.play("ClikcerButtonNormal")

func _on_ClikcerButton_pressed():
	if disableClikcerButton == false:
		Global.clikcs = Global.clikcs + (Global.upgrade1Count + (Global.upgrade2Count*10) + (Global.upgrade3Count*25) + (Global.upgrade4Count*50) + (Global.upgrade5Count*100))
		$ClikcsCounter.set_text("Clikcs: " + str(Global.clikcs))
		disableClikcerButton = true
		$ClickSpeedLimiter.start(0)
		$ClikcerSFX.play(0)

func _on_ClickSpeedLimiter_timeout():
	disableClikcerButton = false

func _on_SettingsButton_pressed():
	$ClikcerSFX.play(0)
	Global.transition_scene_right("Home", "res://scenes/Settings.tscn", .5, Tween.TRANS_SINE, Tween.EASE_OUT)
	#get_tree().change_scene("res://scenes/Settings.tscn")

func _on_VersionLabel_pressed():
	$ClikcerSFX.play(0)
	$Changelog.popup_centered()

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

func _on_AutoSaveTimer_timeout():
	print("saving..")
	save_game()
	print("saved!")

func _on_LeaderboardsButton_pressed():
	$Leaderboards.popup_centered()
	$ClikcerSFX.play(0)

func _on_RefreshScores_pressed():
	if Global.isGuest == false:
		var firestore_collection : FirestoreCollection = Firebase.Firestore.collection("leaderboards")
		firestore_collection.get("BlockyClikcs")
		var document : FirestoreDocument = yield(firestore_collection, "get_document")
		print(document)
	if Global.isGuest == true:
		OS.alert("You need to be signed in to view leaderboards!", "Sorry!")
	pass

func check_for_updates():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	http_request.request("https://raw.githubusercontent.com/Blockyheadman/Clikcer/main/game-version.json")

func _http_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var data = JSON.parse(body.get_string_from_utf8())
		print("online game version (as keypair): "+ str(data.result))
		Global.onlineGameVersion = str(data.result["version"])
		print("online game version (as string): " + Global.onlineGameVersion)
		var splitVersionNumbers = Global.onlineGameVersion.split(".")
		print(str(Global.onlineGameVersion.split(".")))
		Global.onlineVerMajor = int(splitVersionNumbers[0])
		Global.onlineVerMinor = int(splitVersionNumbers[1])
		Global.onlineVerRev = int(splitVersionNumbers[2])
		if Global.gameVersion != Global.onlineGameVersion:
			if Global.onlineVerMajor > Global.verMajor:
				OS.alert("A more recent update (" + Global.onlineGameVersion + ") is available at: https://github.com/Blockyheadman/Clikcer/releases")
				print("Game has a more recent version.")
			if Global.onlineVerMinor > Global.verMinor:
				OS.alert("A more recent update (" + Global.onlineGameVersion + ") is available at: https://github.com/Blockyheadman/Clikcer/releases")
				print("Game has a more recent version.")
			if Global.onlineVerRev > Global.verRev:
				OS.alert("A more recent update (" + Global.onlineGameVersion + ") is available at: https://github.com/Blockyheadman/Clikcer/releases")
				print("Game has a more recent version.")
		else:
			print("Game is up to date!")
		Global.seenUpdateWarning = true
	else:
		if OS.has_feature("debug"):
			OS.alert("Response Code " + str(response_code) + "\nCannot find.")

func _on_Upgrades_pressed():
	$ClikcerSFX.play(0)
	Global.transition_scene_bottom("Home", "res://scenes/Upgrades.tscn", .5, Tween.TRANS_SINE, Tween.EASE_OUT)
	#get_tree().change_scene("res://scenes/Upgrades.tscn")

func _input(event):
	if event is InputEventScreenDrag:
		print(event.relative)
		if event.relative.y <= -35 and Global.disableSwipe == false:# and event.index == 1:
			Global.transition_scene_bottom("Home", "res://scenes/Upgrades.tscn", .5, Tween.TRANS_SINE, Tween.EASE_OUT)
		if event.relative.x <= -35 and Global.disableSwipe == false:# and event.index == 1:
			Global.transition_scene_right("Home", "res://scenes/Settings.tscn", .5, Tween.TRANS_SINE, Tween.EASE_OUT)
