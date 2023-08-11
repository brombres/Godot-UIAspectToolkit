# InitialWindowSizeControl.gd
# UIAspectToolkit
# 2023.08.11 by Brom Bresenham

## A control that sets the initial window size to be its own size if it is the base
## node of the scene. Facilitates testing child scenes individually with a customized aspect
## ratio similar to what their bounds will be when placed in the parent scene.
@tool
class_name InitialWindowSizeControl
extends Control

## The desired initial size of the window. Only takes effect when this node is the base node
## of a scene at runtime.
@export var initial_window_size := Vector2(1280,720):
	set(value):
		initial_window_size = value

		var viewport = get_viewport()
		if not viewport: return  # engine is setting the initial value of this property
		if not Engine.is_editor_hint() or viewport != get_parent(): return

		if value != size: size = value

func _ready():
	if get_parent() == get_viewport() and not Engine.is_editor_hint():
		DisplayServer.window_set_size( initial_window_size )

		var screen_size = Vector2(DisplayServer.screen_get_size())
		var pos = Vector2i( (screen_size-initial_window_size)/2.0 )
		DisplayServer.window_set_position( pos )

		set_anchors_and_offsets_preset( LayoutPreset.PRESET_FULL_RECT )
	else:
		initial_window_size = Vector2i(size)

func _enter_tree():
	if get_parent() == get_viewport():
		resized.connect( on_resized )

func _exit_tree():
	if resized.is_connected( on_resized ):
		resized.disconnect( on_resized )

func on_resized():
	if Engine.is_editor_hint(): initial_window_size = size
