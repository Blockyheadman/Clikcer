extends Control

func _ready():
	OS.min_window_size = Vector2(490, 685)
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
	
	var directory = Directory.new()
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

func _on_FirebaseAuth_signup_succeeded(auth):
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
	get_tree().change_scene("res://scenes/Startup.tscn")
