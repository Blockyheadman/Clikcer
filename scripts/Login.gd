extends Control

var viewport_size

func _ready():
	set_process(false)
	OS.window_resizable = false
	OS.min_window_size = Vector2(490, 685)
	viewport_size = get_viewport_rect().size
	
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		$OnscreenKeyboard.visible = true
		$OnscreenKeyboard.autoShow = true
		$Email.virtual_keyboard_enabled = false
		$Password.virtual_keyboard_enabled = false
		$GoogleLoginPopup/AuthCode.virtual_keyboard_enabled = false
		$ForgotPassWindow/Email.virtual_keyboard_enabled = false
	else:
		$OnscreenKeyboard.visible = false
		$OnscreenKeyboard.autoShow = false
	
	resize_node($Guest)
	resize_node($Email)
	resize_node($Password)
	resize_node($ForgotPass)
	resize_node($RegisterButton)
	resize_node($LoginButton)
	resize_node($SignInGoogle)
	
	$EmailLabel.rect_position = Vector2($EmailLabel.rect_position.x, $EmailLabel.rect_position.y+30)
	$EmailLabel.modulate = Color(1,1,1,0)
	
	$PassLabel.rect_position = Vector2($PassLabel.rect_position.x, $PassLabel.rect_position.y+30)
	$PassLabel.modulate = Color(1,1,1,0)
	
	$LoginLabel.rect_position = Vector2($LoginLabel.rect_position.x, $LoginLabel.rect_position.y+30)
	$LoginLabel.modulate = Color(1,1,1,0)
	
	tween_in($Guest, Vector2(159, 64), Vector2(172, 40), 1.35)
	tween_in($RegisterButton, Vector2(16, 568), Vector2(216, 72), 1.35)
	yield(get_tree().create_timer(0.15), "timeout")
	tween_in($LoginButton, Vector2(258, 568), Vector2(216, 72), 1.35)
	
	yield(get_tree().create_timer(0.25), "timeout")
	tween_in($Email, Vector2(37, 176), Vector2(416, 56), 1.35)
	
	yield(get_tree().create_timer(0.25), "timeout")
	tween_in($Password, Vector2(37, 304), Vector2(416, 56), 1.35)
	
	yield(get_tree().create_timer(0.15), "timeout")
	tween_in($SignInGoogle, Vector2(16, 480), Vector2(458, 72), 1.35)
	
	yield(get_tree().create_timer(0.25), "timeout")
	tween_in($ForgotPass, Vector2(136, 384), Vector2(216, 73), 1.35)
	
	yield(get_tree().create_timer(0.5), "timeout")
	tween_out($EmailLabel, Vector2(40, 152), Vector2(54, 23), 1)
	
	yield(get_tree().create_timer(0.25), "timeout")
	tween_out($PassLabel, Vector2(40, 280), Vector2(92, 23), 1)
	
	yield(get_tree().create_timer(0.5), "timeout")
	tween_out($LoginLabel, Vector2(76, 16), Vector2(338, 40), 1)
	viewport_size = get_viewport_rect().size
	
	"""tween_out($Guest, Vector2(viewport_size.x/2-$Guest.rect_size.x/2, viewport_size.y/2-278.5), Vector2(172, 40), 0.75)
	tween_out($RegisterButton, Vector2(viewport_size.x/2-$RegisterButton.rect_size.x*1.065, viewport_size.y/2+225.5), Vector2(216, 72), 0.75)
	yield(get_tree().create_timer(0.15), "timeout")
	tween_out($LoginButton, Vector2(viewport_size.x/2+$LoginButton.rect_size.x*0.065, viewport_size.y/2+225.5), Vector2(216, 72), 0.75)
	yield(get_tree().create_timer(0.25), "timeout")
	tween_out($Email, Vector2(viewport_size.x/2-$Email.rect_size.x/2, viewport_size.y/2-166.5), Vector2(416, 56), 0.75)
	yield(get_tree().create_timer(0.25), "timeout")
	tween_out($Password, Vector2(viewport_size.x/2-$Password.rect_size.x/2, viewport_size.y/2-38.5), Vector2(416, 56), 0.75)
	yield(get_tree().create_timer(0.15), "timeout")
	tween_out($SignInGoogle, Vector2(viewport_size.x/2-$SignInGoogle.rect_size.x/2, viewport_size.y/2+137.5), Vector2(458, 72), 0.75)
	yield(get_tree().create_timer(0.25), "timeout")
	tween_out($ForgotPass, Vector2(viewport_size.x/2-$ForgotPass.rect_size.x/2, viewport_size.y/2+41.5), Vector2(216, 73), 0.75)
	yield(get_tree().create_timer(0.5), "timeout")
	tween_out($EmailLabel, Vector2($Email.rect_position.x+3, viewport_size.y/2-190.5), Vector2(54, 23), 0.75)
	yield(get_tree().create_timer(0.25), "timeout")
	tween_out($PassLabel, Vector2($Password.rect_position.x+3, viewport_size.y/2-61.5), Vector2(92, 23), 0.75)
	yield(get_tree().create_timer(0.5), "timeout")
	tween_out($LoginLabel, Vector2(viewport_size.x/2-$LoginLabel.rect_size.x/2, viewport_size.y/2-322.5), Vector2(338, 40), 0.75)"""
	
	yield(get_tree().create_timer(1), "timeout")
	set_process(true)
	
	OS.window_resizable = true
	$QuitTouchPanel.queue_free()
	
	if Firebase._config["apiKey"] != "":
		Global.loginAvailable = true
		Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
		Firebase.Auth.connect("signup_succeeded", self, "_on_FirebaseAuth_signup_succeeded")
		Firebase.Auth.connect("login_failed", self, "on_login_failed")
		Firebase.Auth.connect("signup_failed", self, "on_signup_failed")
	else:
		printerr("Godot Firebase Addon not configured properly. Moving to startup scene. Please configure the addon's settings properly to enable Sign-ins.")
		Global.loginAvailable = false
		get_tree().change_scene("res://scenes/Startup.tscn")
	
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		$SignInGoogle.disabled = true
		$SignInGoogle.hint_tooltip = "Google sign-in is not currently available on the device."
		$SignInGoogle.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

func _process(_delta):
	print("running process")
	set_process(false)
	viewport_size = get_viewport_rect().size
	
	tween_out($Guest, Vector2(viewport_size.x/2-$Guest.rect_size.x/2, viewport_size.y/2-278.5), Vector2(172, 40), 0.75)
	
	tween_out($RegisterButton, Vector2(viewport_size.x/2-$RegisterButton.rect_size.x*1.065, viewport_size.y/2+225.5), Vector2(216, 72), 0.75)
	
	tween_out($LoginButton, Vector2(viewport_size.x/2+$LoginButton.rect_size.x*0.065, viewport_size.y/2+225.5), Vector2(216, 72), 0.75)
	
	tween_out($Email, Vector2(viewport_size.x/2-$Email.rect_size.x/2, viewport_size.y/2-166.5), Vector2(416, 56), 0.75)
	
	tween_out($Password, Vector2(viewport_size.x/2-$Password.rect_size.x/2, viewport_size.y/2-38.5), Vector2(416, 56), 0.75)
	
	tween_out($SignInGoogle, Vector2(viewport_size.x/2-$SignInGoogle.rect_size.x/2, viewport_size.y/2+137.5), Vector2(458, 72), 0.75)
	
	tween_out($ForgotPass, Vector2(viewport_size.x/2-$ForgotPass.rect_size.x/2, viewport_size.y/2+41.5), Vector2(216, 73), 0.75)
	
	tween_out($EmailLabel, Vector2($Email.rect_position.x+3, viewport_size.y/2-190.5), Vector2(54, 23), 0.75)
	
	tween_out($PassLabel, Vector2($Password.rect_position.x+3, viewport_size.y/2-61.5), Vector2(92, 23), 0.75)
	
	tween_out($LoginLabel, Vector2(viewport_size.x/2-$LoginLabel.rect_size.x/2, viewport_size.y/2-322.5), Vector2(338, 40), 0.75)
	
	yield(get_tree().create_timer(0.75), "timeout")
	
	set_process(true)

func tween_in(node, position : Vector2, size : Vector2, time : float):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "rect_position", position, time)
	tween.parallel().tween_property(node, "rect_size", size, time)
	tween.parallel().tween_property(node, "modulate", Color(1,1,1,1), time)

func tween_out(node, position : Vector2, size : Vector2, time : float):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "rect_position", position, time)
	tween.parallel().tween_property(node, "rect_size", size, time)
	tween.parallel().tween_property(node, "modulate", Color(1,1,1,1), time)

func resize_node(node):
	node.rect_size = Vector2(node.rect_size.x+300, node.rect_size.y+300)
	node.rect_position = Vector2(node.rect_position.x-150, node.rect_position.y-150)
	node.modulate = Color(1,1,1,0)

func _on_SignInGoogle_pressed():
	$ClikcerSFX.play(0)
	$OnscreenKeyboard._hideKeyboard()
	Firebase.Auth.get_auth_localhost()
	"""if OS.get_name() == "Windows" or OS.get_name() == "X11" or OS.get_name() == "OSX":
		Firebase.Auth.get_auth_localhost()
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		$OnscreenKeyboard._hideKeyboard()
		$ForgotPassWindow.visible = false
		$GuestPrompt.visible = false
		#$GoogleLoginPopup.popup_centered()
		#Firebase.Auth.set_redirect_uri("http://localhost:8060/")"""

# mobile login system
func _on_GetAuthCode_pressed():
	$ClikcerSFX.play(0)
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.set_redirect_uri("http://localhost:5000")
	print("Waiting for an authorization code...")
	Firebase.Auth.get_auth_with_redirect(provider)

func _on_SignIn_pressed():
	$ClikcerSFX.play(0)
	print("Exchanging authorization code with a oath token...")
	Firebase.Auth.login_with_oauth($GoogleLoginPopup/AuthCode.get_text(), Firebase.Auth.get_GoogleProvider())

# email sign in functions
func _on_FirebaseAuth_login_succeeded(auth):
	#var user = Firebase.Auth.get_user_data()
	#print(user)
	Global.userInfo = auth
	Global.username = auth["displayname"]
	Global.isGuest = false
	get_tree().change_scene("res://scenes/Startup.tscn")

func _on_FirebaseAuth_signup_succeeded(_auth):
	var user = Firebase.Auth.get_user_data()
	print(user)
	OS.alert("ClikcerOnline user created!")
	#Firebase.Auth.send_account_verification_email()

func on_login_failed(error_code, message):
	print("login error code: " + str(error_code))
	print("message: " + str(message))
	if str(message) == "USER_DISABLED":
		OS.alert("Your account is disabled.")
	if str(message) == "WEAK_PASSWORD":
		OS.alert("Password to weak.")

func on_signup_failed(error_code, message):
	print("signup error code: " + str(error_code))
	print("message: " + str(message))
	if str(message) == "EMAIL_EXISTS":
		OS.alert("That email is already being used!")

func _on_RegisterButton_pressed():
	$ClikcerSFX.play(0)
	var email = $Email.text
	var password = $Password.text
	Firebase.Auth.signup_with_email_and_password(email, password)

func _on_LoginButton_pressed():
	$ClikcerSFX.play(0)
	var email = $Email.text
	var password = $Password.text
	Firebase.Auth.login_with_email_and_password(email, password)

# forgot pass stuff
func _on_ForgotPass_pressed():
	$ClikcerSFX.play(0)
	$OnscreenKeyboard._hideKeyboard()
	$GoogleLoginPopup.visible = false
	$GuestPrompt.visible = false
	$ForgotPassWindow.popup_centered()

func _on_ResetPass_pressed():
	$ClikcerSFX.play(0)
	var email = $ForgotPassWindow/Email.text
	Firebase.Auth.send_password_reset_email(email)
	$ForgotPassWindow.visible = false

# continue as guest
func _on_Guest_pressed():
	$ClikcerSFX.play(0)
	$OnscreenKeyboard._hideKeyboard()
	$ForgotPassWindow.visible = false
	$GoogleLoginPopup.visible = false
	$GuestPrompt.popup_centered()

func _on_Accept_pressed():
	$ClikcerSFX.play(0)
	Global.isGuest = true
	$GuestPrompt.hide()
	
	Global.transition_scene_bottom("Login", "res://scenes/Home.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT)
	#get_tree().change_scene("res://scenes/Startup.tscn")
