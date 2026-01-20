#!!This file could go in the Git ignnore if there will be settings saved that need to be encrypted!!
#!!because of Passwords!!
extends Node
#Can be just changed in Editor
const SETTINGS_PATH = "user://settings.cfg"

@export var WebBuild:bool = true
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")

var config = ConfigFile.new()

#Can be changed in SettingsMenu Settings
var automaticSwitcher:bool = false
var vsynch:bool = false
var animations:bool = false
var language = "automatic"
var SynchroniseOffset:float = 0.0
var MasterSound:float = 0.8
var SFXSound:float = 0.8
var MusicSound:float = 0.8


func loadSettings():
	
	MasterSound = config.get_value("audio","master_volume",0.8)
	SFXSound = config.get_value("audio","SFX_volume",0.8)
	MusicSound = config.get_value("audio","music_volume",0.8)
	language = config.get_value("gamePlay","language","automatic")
	animations = config.get_value("gamePlay","animations",false)
	automaticSwitcher = config.get_value("gamePlay","switch_house",false)

#To note not every Settings needs to be set because some veriables are
#used in game, so it just needs to be loaded
func setSettings():
	
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
		language = preferred_language
	else:
		TranslationServer.set_locale(language)
	MasterChanged(MasterSound)
	SFXChanged(SFXSound)
	MusicChanged(MusicSound)
#load and set veriavles
func  _ready():
	var err = config.load(SETTINGS_PATH)
	
	if err == OK:
		loadSettings()
	setSettings()
	
func setLanguge(languages):
	language = languages
	TranslationServer.set_locale(languages)
	SaveFile()
func SaveFile():
	config.set_value("audio", "master_volume", MasterSound)
	config.set_value("audio","music_volume",MusicSound)
	config.set_value("audio","SFX_volume",SFXSound)
	config.set_value("gamePlay","language",language)
	config.set_value("gamePlay","switch_house",automaticSwitcher)
	config.set_value("gamePlay","animations",animations)
	#THIS Can BE ENCRYPTED
	config.save(SETTINGS_PATH)
	
	
func MasterChanged(value):
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MASTER_BUS_ID, value < .05)
	SaveFile()

func MusicChanged(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)
	SaveFile()


func SFXChanged(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)
	SaveFile()
