extends Popup


func _on_check_box_toggled(toggled_on):
	GlobalSettings.vsynch = toggled_on
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_popup_hide():
	get_tree().paused = false
