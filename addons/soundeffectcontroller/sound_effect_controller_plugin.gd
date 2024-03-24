@tool
extends EditorPlugin

func _enter_tree():
		add_custom_type("SoundEffectController", "Node", \
		preload("res://addons/soundeffectcontroller/sound_effect_controller/sound_effect_controller.gd"), \
		preload("res://addons/soundeffectcontroller/sound_effect_controller/sound_effect_controller.svg"))

func _exit_tree():
	remove_custom_type("SoundEffectController")
