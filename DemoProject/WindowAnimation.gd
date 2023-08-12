extends Node2D

var tween:Tween
var window_width  := 206
var window_height := 221

# Called when the node enters the scene tree for the first time.
func _process( _delta ):
	if not is_visible(): return

	if not tween or not tween.is_running():
		tween = create_tween()
		tween.tween_interval( 1 )
		tween.tween_property( self, "window_width", 440, 2 )
		tween.tween_interval( 1 )
		tween.tween_property( self, "window_height", 500, 2 )
		tween.tween_interval( 1 )
		tween.tween_property( self, "window_width", 206, 2 )
		tween.tween_interval( 1 )
		tween.tween_property( self, "window_height", 221, 2 )

	if tween:
		DisplayServer.window_set_size( Vector2i(window_width,window_height) )
