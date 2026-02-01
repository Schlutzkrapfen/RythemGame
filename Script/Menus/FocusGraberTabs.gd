extends VBoxContainer
@export var selcted:Control


func _on_visibility_changed():
	if is_visible_in_tree():
		selcted.grab_focus()
