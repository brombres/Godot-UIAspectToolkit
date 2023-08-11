# RigidHBoxContainer.gd
# UIAspectToolkit
# 2023.08.11 by Brom Bresenham

## An HBoxContainer that does not grow larger than its original bounds
## regardless of the minimum size of its children. Necessary if using a dynamic
## layout with an AspectRatioControl among the children, bacause after the
## AspectRatioControl sets its minimum height based on the parent VBox size, a
## standard VBox will expand to that height and maintain that height even when
## scaled down.
@tool
class_name RigidHBoxContainer
extends Container

func _ready():
	sort_children.connect( on_sort_children )

func on_sort_children():
	var min_width := 0
	var expand_count := 0
	var total_stretch_ratio := 0.0

	# Gather child height info
	for i in range(get_child_count()):
		var child = get_child(i)
		min_width += child.get_combined_minimum_size().x
		if child.size_flags_horizontal & SizeFlags.SIZE_EXPAND:
			expand_count += 1
			total_stretch_ratio += size_flags_stretch_ratio

	var excess_width = size.x - min_width
	if excess_width < 0: excess_width = 0

	# Assign position & distribute info
	var pos_x := 0
	var remaining_width = excess_width  # remaining height to distribute via fill or expand
	for i in range(get_child_count()):
		var child = get_child(i)
		var child_size = child.get_combined_minimum_size()

		var w = int(child_size.x)
		if child.size_flags_horizontal & SizeFlags.SIZE_EXPAND:
			if expand_count == 1:
				w += remaining_width
			else:
				var dw = int( excess_width * child.size_flags_stretch_ratio / total_stretch_ratio )
				w += dw
				remaining_width -= dw
				expand_count -= 1

		var pos_y := 0
		var h = int(child_size.y)
		if h < size.y and (child.size_flags_vertical & SizeFlags.SIZE_EXPAND):
			h = size.y
		elif (child.size_flags_vertical & SizeFlags.SIZE_SHRINK_CENTER) or \
				(child.size_flags_vertical & SizeFlags.SIZE_FILL):
			pos_y = int( (size.y - h) / 2 )
		elif child.size_flags_vertical & SizeFlags.SIZE_SHRINK_END:
			pos_y = int(size.y - h)

		fit_child_in_rect( child, Rect2(pos_x,pos_y,w,h) )
		pos_x += w

