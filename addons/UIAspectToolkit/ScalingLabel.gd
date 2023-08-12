# ScalingLabel.gd
# UIAspectToolkit
# 2023.08.04 by Brom Bresenham
#
# USAGE
#  1. Control > Theme Overrides > Font Size (etc.) -> ...
#  2. Position and size text relative to parent as desired.
#  3. Click the 'lock_reference_values' property checkbox button when the text
#     is positioned and scaled as you want it to be in the editor.
#  4. Now the text will correctly scale with its node.

## A Label with text that correctly scales with the size of its node.
@tool
class_name ScalingLabel
extends Label

## Check to lock in the current font size and node height as reference values
## that will be used to scale the font size at runtime.
@export var lock_reference_values:bool:
	set(setting):
		lock_reference_values = setting
		if not get_parent(): return  # resource loading is setting properties

		if setting:
			reference_node_height = size.y
			reference_font_size = get_theme_font_size("font_size")
		else:
			reference_node_height = 0
			reference_font_size = 0

## The height of the [Label] node that the [member reference_font_size] was designed for.
## This is used to scale the font based on the current height of the node.
@export var reference_node_height := 0.0

# The original size of the font.
@export var reference_font_size := 0.0

var cur_scale := 1.0

func _enter_tree():
	resized.connect( on_resized )

func _exit_tree():
	if resized.is_connected( on_resized ):
		resized.disconnect( on_resized )

func on_resized():
	if reference_node_height and reference_font_size:
		cur_scale = (size.y / reference_node_height)
		var cur_size = reference_font_size * cur_scale
		if cur_size: add_theme_font_size_override( "font_size", cur_size )

