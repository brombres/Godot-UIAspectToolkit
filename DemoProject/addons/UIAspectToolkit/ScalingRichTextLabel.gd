# ScalingRichTextLabel.gd
# UIAspectToolkit
# 2023.08.04 by Brom Bresenham
#
# USAGE
#  1. Anchors -> Full Rect
#  2. RichTextLabel > BBCode Enabled -> On
#  3. RichTextLabel > Text -> "[center]My Text ..." etc.
#  4. RichTextLabel > Scroll Active -> Off (optional)
#  5. Control > Theme Overrides > Font Sizes > Normal Font Size (etc.) -> ...
#  6. Click on the Anchor icon above the view so that the anchors move with the
#     bounding box. Or else be sure to move the anchors to the red dots later.
#  7. Use the red dots to position the transform bounding box.
#     NOTE: Be sure to leave the node 'scale' at (1,1) in the inspector.
#  8. Click 'lock_reference_values' when the text is positioned and scaled as
#     you want it to be in the editor.
#  9. Now the text will correctly scale with its node.

## A RichTextLabel with text that correctly scales with the size of its node.
@tool
class_name ScalingRichTextLabel
extends RichTextLabel

## Check to lock in the current font size and node height as reference values
## that will be used to scale the font size at runtime.
@export var lock_reference_values:bool:
	set(setting):
		lock_reference_values = setting
		if not get_parent(): return  # resource loading is setting properties

		if setting:
			reference_node_height = ceil(size.y)

			# Ensure the reference_font_sizes array is large enough.
			while reference_font_sizes.size() < fonts.size():
				reference_font_sizes.push_back(0)

			# Save all the current font sizes as reference values.
			for i in range(fonts.size()):
				var font_name = fonts[i] + "_font_size"
				reference_font_sizes[i] = get_theme_font_size( font_name )

		else:
			reference_node_height = 0
			for i in range(fonts.size()):
				reference_font_sizes[i] = 0

## The height of the [RichTextLabel] node that the [member reference_font_size] was designed for.
## This is used to scale the font based on the current height of the node.
@export var reference_node_height:float = 0

# The original size of each font.
@export var reference_font_sizes:Array[float] = [0,0,0,0,0]

## The fonts that will be auto-scaled for this node.
@export var fonts:Array[String] = \
	["normal","bold","italics","bold_italics","mono"]

var is_ready  := false
var cur_scale := 1.0

func _enter_tree():
	resized.connect( on_resized )

func _exit_tree():
	if resized.is_connected( on_resized ):
		resized.disconnect( on_resized )

func _ready():
	is_ready = true
	on_resized()

func on_resized():
	if not is_ready: return # if fit_content is enabled there will be a bunch of resizes before _ready

	if reference_node_height:
		cur_scale = (ceil(size.y) / reference_node_height)

		# Override the size of each font
		for i in range(fonts.size()):
			var cur_size = reference_font_sizes[i] * cur_scale
			if cur_size: add_theme_font_size_override( fonts[i]+"_font_size", cur_size )

