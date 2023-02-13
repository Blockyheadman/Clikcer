extends Node

var verMajor = 0
var verMinor = 5
var verRev = 0
var gameVersion = str(verMajor) + "." + str(verMinor) + "." + str(verRev)
var onlineGameVersion
var onlineVerMajor
var onlineVerMinor
var onlineVerRev
var seenUpdateWarning := false

var username : String
var userInfo = null
var loginAvailable : bool

var isGuest : bool
var emailSignIn : bool
var googleSignIn : bool

var AutoSaveEnabled := true
var AutoSaveSliderValue := 1

var clikcs := 0
var upgrade1Count := 1
var upgrade2Count := 0
var upgrade3Count := 0
var upgrade4Count := 0
var upgrade5Count := 0
var upgrade1Cost := 300
var upgrade2Cost := 2500
var upgrade3Cost := 14500
var upgrade4Cost := 28000
var upgrade5Cost := 285000

var achievement1 := false
var achievement1Claimed := false
var achievement2 := false
var achievement2Claimed := false
var achievement3 := false
var achievement3Claimed := false
var achievement4 := false
var achievement4Claimed := false
var achievement5 := false
var achievement5Claimed := false

var viewport_size
var disableSwipe = false

#func _ready():
#	if OS.get_name() == "Android" or OS.get_name() == "iOS":
#		Firebase._config{}

func _process(_delta):
	viewport_size = get_viewport().size


# Example Transition: Global.transition_scene_*TYPE*("Login", "res://scenes/Home.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT)
func transition_scene_bottom(old_scene : String, new_scene_path : String, time : float, transition_type, ease_type):
	disableSwipe = true
	OS.window_resizable = false
	var scene = load(new_scene_path).instance()
	get_tree().get_root().add_child(scene, true)
	
	var scene_node = get_tree().get_root().get_node(scene.name)
	#scene_node.rect_size = viewport_size
	var no_click = Control.new()
	no_click.rect_size = viewport_size
	no_click.mouse_filter = Control.MOUSE_FILTER_STOP
	
	print(viewport_size)
	print(scene_node.rect_size)
	
	var no_click2 = Control.new()
	no_click2.rect_size = viewport_size
	no_click2.mouse_filter = Control.MOUSE_FILTER_STOP
	
	get_parent().get_node(scene_node.name).add_child(no_click, true)
	get_parent().get_node(old_scene).add_child(no_click2, true)
	
	scene_node.rect_position = Vector2(0, viewport_size.y)
	#scene_node.rect_position = Vector2(viewport_size.x/2, viewport_size.y)
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(transition_type)
	tween.tween_property(scene_node, "rect_position", Vector2(0, 0), time)
	
	yield(get_tree().create_timer(time), "timeout")
	
	get_viewport().get_node(old_scene).queue_free()
	get_parent().get_node(scene_node.name).get_node(no_click.name).queue_free()
	get_parent().get_node(old_scene).get_node(no_click2.name).queue_free()
	
	OS.window_resizable = true
	disableSwipe = false

func transition_scene_top(old_scene : String, new_scene_path : String, time : float, transition_type, ease_type):
	disableSwipe = true
	OS.window_resizable = false
	var scene = load(new_scene_path).instance()
	get_tree().get_root().add_child(scene, true)
	
	var scene_node = get_tree().get_root().get_node(scene.name)
	var no_click = Control.new()
	no_click.rect_size = viewport_size
	no_click.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var no_click2 = Control.new()
	no_click2.rect_size = viewport_size
	no_click2.mouse_filter = Control.MOUSE_FILTER_STOP
	
	get_parent().get_node(scene_node.name).add_child(no_click, true)
	get_parent().get_node(old_scene).add_child(no_click2, true)
	
	scene_node.rect_position = Vector2(0, -viewport_size.y)
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(transition_type)
	tween.tween_property(scene_node, "rect_position", Vector2(0, 0), time)
	
	yield(get_tree().create_timer(time), "timeout")
	get_viewport().get_node(old_scene).queue_free()
	get_parent().get_node(scene_node.name).get_node(no_click.name).queue_free()
	get_parent().get_node(old_scene).get_node(no_click2.name).queue_free()
	
	OS.window_resizable = true
	disableSwipe = false

func transition_scene_left(old_scene : String, new_scene_path : String, time : float, transition_type, ease_type):
	disableSwipe = true
	OS.window_resizable = false
	var scene = load(new_scene_path).instance()
	get_tree().get_root().add_child(scene, true)
	
	var scene_node = get_tree().get_root().get_node(scene.name)
	var no_click = Control.new()
	no_click.rect_size = viewport_size
	no_click.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var no_click2 = Control.new()
	no_click2.rect_size = viewport_size
	no_click2.mouse_filter = Control.MOUSE_FILTER_STOP
	
	get_parent().get_node(scene_node.name).add_child(no_click, true)
	get_parent().get_node(old_scene).add_child(no_click2, true)
	
	scene_node.rect_position = Vector2(-viewport_size.x, 0)
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(transition_type)
	tween.tween_property(scene_node, "rect_position", Vector2(0, 0), time)
	
	yield(get_tree().create_timer(time), "timeout")
	get_viewport().get_node(old_scene).queue_free()
	get_parent().get_node(scene_node.name).get_node(no_click.name).queue_free()
	get_parent().get_node(old_scene).get_node(no_click2.name).queue_free()
	
	OS.window_resizable = true
	disableSwipe = false

func transition_scene_right(old_scene : String, new_scene_path : String, time : float, transition_type, ease_type):
	disableSwipe = true
	OS.window_resizable = false
	var scene = load(new_scene_path).instance()
	get_tree().get_root().add_child(scene, true)
	
	var scene_node = get_tree().get_root().get_node(scene.name)
	var no_click = Control.new()
	no_click.rect_size = viewport_size
	no_click.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var no_click2 = Control.new()
	no_click2.rect_size = viewport_size
	no_click2.mouse_filter = Control.MOUSE_FILTER_STOP
	
	get_parent().get_node(scene_node.name).add_child(no_click, true)
	get_parent().get_node(old_scene).add_child(no_click2, true)
	
	scene_node.rect_position = Vector2(viewport_size.x, 0)
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(transition_type)
	tween.tween_property(scene_node, "rect_position", Vector2(0, 0), time)
	
	yield(get_tree().create_timer(time), "timeout")
	get_viewport().get_node(old_scene).queue_free()
	get_parent().get_node(scene_node.name).get_node(no_click.name).queue_free()
	get_parent().get_node(old_scene).get_node(no_click2.name).queue_free()
	
	OS.window_resizable = true
	disableSwipe = false
