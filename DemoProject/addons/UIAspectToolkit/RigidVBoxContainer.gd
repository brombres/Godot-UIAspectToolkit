# RigidVBoxContainer.gd
# UIAspectToolkit
# 2023.08.11 by Brom Bresenham

## A VBoxContainer that does not grow larger than its original bounds regardless
## of the minimum size of its children. Necessary if using a dynamic layout with
## an AspectRatioControl among the children, bacause after the
## AspectRatioControl sets its minimum width based on the parent VBox size, a
## standard VBox will expand to that width and maintain that width even when
## scaled down.
@tool
class_name RigidVBoxContainer
extends Container

func _ready():
	sort_children.connect( on_sort_children )

func on_sort_children():
	var min_height := 0
	var expand_count := 0
	var total_stretch_ratio := 0.0

	# Gather child height info
	for i in range(get_child_count()):
		var child = get_child(i)
		min_height += child.get_combined_minimum_size().y
		if child.size_flags_vertical & SizeFlags.SIZE_EXPAND:
			expand_count += 1
			total_stretch_ratio += size_flags_stretch_ratio

	var excess_height = size.y - min_height
	if excess_height < 0: excess_height = 0

	# Assign position & distribute info
	var pos_y := 0
	var remaining_height = excess_height  # remaining height to distribute via fill or expand
	for i in range(get_child_count()):
		var child = get_child(i)
		var child_size = child.get_combined_minimum_size()

		var h = int(child_size.y)
		if child.size_flags_vertical & SizeFlags.SIZE_EXPAND:
			if expand_count == 1:
				h += remaining_height
			else:
				var dh = int( excess_height * child.size_flags_stretch_ratio / total_stretch_ratio )
				h += dh
				remaining_height -= dh
				expand_count -= 1

		var pos_x := 0
		var w = int(child_size.x)
		if w < size.x and (child.size_flags_horizontal & SizeFlags.SIZE_EXPAND):
			w = size.x
		elif (child.size_flags_horizontal & SizeFlags.SIZE_SHRINK_CENTER) or \
				(child.size_flags_horizontal & SizeFlags.SIZE_FILL):
			pos_x = int( (size.x - w) / 2 )
		elif child.size_flags_horizontal & SizeFlags.SIZE_SHRINK_END:
			pos_x = int(size.x - w)

		fit_child_in_rect( child, Rect2(pos_x,pos_y,w,h) )
		pos_y += h

