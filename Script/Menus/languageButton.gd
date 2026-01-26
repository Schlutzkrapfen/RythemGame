extends HBoxContainer
@export var optionButton:OptionButton
var supported_languages = TranslationServer.get_loaded_locales()

func _ready():
	for language in supported_languages:
		optionButton.add_item(language)
	optionButton.select(supported_languages.find(GlobalSettings.language))

func _on_option_button_item_selected(index):
	GlobalSettings.setLanguge(supported_languages[index])
