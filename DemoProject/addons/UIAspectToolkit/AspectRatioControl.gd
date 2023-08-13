# AspectRatioControl.gd
# UIAspectToolkit
# 2023.08.11 by Brom Bresenham

## A control which auto-adjusts its minimum size to reflect a specified
## [member aspect] ratio within its parent bounds. The parent container should
## generally be type [RigidHBoxContainer] or [RigidVBoxContainer] rather than
## standard [HBoxContainer] and [VBoxContainer].
@tool
class_name AspectRatioControl
extends Control

enum Mode
{
	ASPECT,           ## Sets this node's minimum size to reflect a specific [member aspect] ratio within its parent's bounds.
	ASPECT_OR_WIDER,  ## Sets this node's minimum height based on the specified [member aspect] ratio.
	ASPECT_OR_TALLER  ## Sets this node's minimum width based on the specified [member aspect] ratio.
}

# PROPERTIES

## Determines whether the [member aspect] size is applied to this node's minimum width, minimum height, or both.
@export var mode := Mode.ASPECT:
	set(value):
		mode = value
		match value:
			Mode.ASPECT: pass
			Mode.ASPECT_OR_WIDER:  custom_minimum_size.x = 0
			Mode.ASPECT_OR_TALLER: custom_minimum_size.y = 0
		adjust_size()

## The aspect ratio that will be used to adjust this node's minimum size based on its parent's size.
## Any scale can be used; only the ratio matters. For example, (3,2) (meaning 3:2) has the same effect as (480,320).
@export var aspect := Vector2(1,1):
	set(value):
		if value.x <= 0: value.x = 1
		if value.y <= 0: value.y = 1
		aspect = value
		adjust_size()

# METHODS

func _ready():
	adjust_size()

func _enter_tree():
	get_parent().resized.connect( adjust_size )

func _exit_tree():
	var parent = get_parent()
	if parent.resized.is_connected( adjust_size ):
		parent.resized.disconnect( adjust_size )

func adjust_size():
	var parent = get_parent()
	if not parent: return

	var parent_size = parent.size

	var fit_w = int(parent_size.y * (aspect.x / aspect.y))  # aspect pixel width given current height
	var fit_h = int(parent_size.x * (aspect.y / aspect.x))  # aspect pixel height given current width

	match mode:
		Mode.ASPECT:
			if fit_w <= parent_size.x:
				custom_minimum_size.x = fit_w
				custom_minimum_size.y = parent_size.y
			else:
				custom_minimum_size.x = parent_size.x
				custom_minimum_size.y = fit_h

		Mode.ASPECT_OR_WIDER:
			if fit_h <= parent_size.y:
				custom_minimum_size.x = parent_size.x
				custom_minimum_size.y = fit_h
			else:
				custom_minimum_size = parent_size

		Mode.ASPECT_OR_TALLER:
			if fit_w <= parent_size.x:
				custom_minimum_size.x = fit_w
				custom_minimum_size.y = parent_size.y
			else:
				custom_minimum_size = parent_size

	size = custom_minimum_size
