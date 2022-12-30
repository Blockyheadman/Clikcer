extends Node

var verMajor = 0
var verMinor = 4
var verRev = 1
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

#func _ready():
#	if OS.get_name() == "Android" or OS.get_name() == "iOS":
#		Firebase._config{}
