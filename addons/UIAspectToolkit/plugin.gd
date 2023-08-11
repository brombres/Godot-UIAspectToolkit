# plugin.gd
# UIAspectToolkit
# 2023.08.11 by Brom Bresenham
@tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("AspectRatioControl",       "Control",     preload("AspectRatioControl.gd"), preload("AspectRatioControl.svg"))
	add_custom_type("InitialWindowSizeControl", "Control",     preload("InitialWindowSizeControl.gd"), preload("InitialWindowSizeControl.svg"))
	add_custom_type("RigidHBoxContainer",       "Container",   preload("RigidHBoxContainer.gd"), preload("RigidHBoxContainer.svg"))
	add_custom_type("RigidVBoxContainer",       "Container",   preload("RigidVBoxContainer.gd"), preload("RigidVBoxContainer.svg"))
	add_custom_type("MaxSizeContainer",     "MarginContainer", preload("MaxSizeContainer.gd"), preload("MaxSizeContainer.svg"))
	add_custom_type("ScalingRichTextLabel", "RichTextLabel",   preload("ScalingRichTextLabel.gd"), preload("ScalingRichTextLabel.svg"))

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("AspectRatioControl")
	remove_custom_type("InitialWindowSizeControl")
	remove_custom_type("RigidHBoxContainer")
	remove_custom_type("RigidVBoxContainer")
	remove_custom_type("MaxSizeContainer")
	remove_custom_type("ScalingRichTextLabel")
