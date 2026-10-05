extends CanvasLayer

var visibility: visibilities
enum visibilities {TOUCH,ALWAYS,NEVER}

var pos_type: pos_types
enum pos_types {FLOATING,FIXED}

var float_type: float_types
enum float_types {FULL,BOTTOM,BOTTOM_LEFT,BOTTOM_RIGHT}

var fixed_type: fixed_types
enum fixed_types {SINGLE,TWIN}

var base_mode: base_modes
enum base_modes {STATIC,DYNAMIC}

var radius = 35

func _input(event):
	MobileInputs.joystick_single_output.emit(get_direction())
	if event is InputEventScreenTouch:
		if event.is_pressed():
			check_joystick_type(event)
			if touch_is_in_region(event.position):
				set_visibility(true)
		else:
			center_joystick_to_screen()
			if touch_is_in_region(event.position):
				set_visibility(false)

	elif event is InputEventScreenDrag:
		if event.pressure:
			if touch_is_in_region(event.position):
				set_visibility(true)
		else:
			if touch_is_in_region(event.position):
				set_visibility(false)
		var base_center = %Base.position + %Base.texture.get_size() / 2
		
		match base_mode:
			base_modes.STATIC:
				if touch_is_in_region(event.position):
					center_tracker_to_base(event.position)
				
			base_modes.DYNAMIC:
				var tracker_size: Vector2 = %Tracker.texture.get_size()
				%Tracker.global_position = event.position - tracker_size / 2
				
				var tracker_center: Vector2 = %Tracker.global_position + tracker_size / 2
				var distance: float = (tracker_center - base_center).length()
				
				if distance > radius:
					var direction: Vector2 = (tracker_center - base_center).normalized()
					%Base.position = tracker_center - direction * radius - %Base.texture.get_size() / 2

func get_direction() -> Vector2:
	var base_center: Vector2 = %Base.position + %Base.texture.get_size() / 2
	var tracker_center: Vector2 = %Tracker.global_position + %Tracker.texture.get_size() / 2
	var direction: Vector2 = (tracker_center - base_center).normalized()
	if MobileInputs.mobile_input_config.invert_y_axis:
		if not MobileInputs.mobile_input_config.movement_in_3D:
			direction.y *= -1
	else:
		if  MobileInputs.mobile_input_config.movement_in_3D:
			direction.y *= -1
	return direction
	
func set_visibility(make_visible:bool) -> void:
	if make_visible:
		match visibility:
			visibilities.TOUCH:
				%Base.visible = true
			visibilities.ALWAYS:
				%Base.visible = true
			visibilities.NEVER:
				%Base.visible = false
	else:
		match visibility:
			visibilities.TOUCH:
				%Base.visible = false
			visibilities.ALWAYS:
				print("am visible")
				%Base.visible = true
			visibilities.NEVER:
				%Base.visible = false
				
func touch_is_in_region(touch_pos) -> bool:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	match pos_type:
		pos_types.FLOATING:
			match float_type:
				float_types.FULL:
					return true
				float_types.BOTTOM:
					return touch_pos.y > screen_size.y /2
				float_types.BOTTOM_LEFT:
					return touch_pos.y > screen_size.y /2 and touch_pos.x < screen_size.x /2
				float_types.BOTTOM_RIGHT:
					return touch_pos.y > screen_size.y /2 and touch_pos.x > screen_size.x /2
				_:
					return false
		_:
			return false

func check_joystick_type(event) -> void:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	match pos_type:
		pos_types.FLOATING:
			if touch_is_in_region(event.position):
				center_tracker_and_base_to_touch(event.position)
					
		pos_types.FIXED:
			match fixed_type:
				fixed_types.SINGLE:
					pass
				fixed_types.TWIN:
					pass

func center_tracker_and_base_to_touch(touch_pos: Vector2):
	var base_size: Vector2 = %Base.texture.get_size()
	var tracker_size: Vector2 = %Tracker.texture.get_size()
	%Base.position = touch_pos - base_size / 2
	%Tracker.global_position = touch_pos - tracker_size / 2

func center_tracker_to_base(touch_pos: Vector2):
	var base_center: Vector2 = %Base.position + %Base.texture.get_size() / 2
	var direction: Vector2 = (touch_pos - base_center).limit_length(radius)
	var tracker_size: Vector2 = %Tracker.texture.get_size()
	%Tracker.global_position = base_center + direction - tracker_size / 2
	
func center_joystick_to_screen() -> void:
	var screen_center: Vector2 = get_viewport().get_visible_rect().size / 2
	var base_size: Vector2 = %Base.texture.get_size()
	var tracker_size: Vector2 = %Tracker.texture.get_size()
	
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	
	match float_type:
		float_types.FULL:
			var center = screen_size / 2
			%Base.position = center - base_size / 2
			%Tracker.global_position = center - tracker_size / 2
			
		float_types.BOTTOM:
			var bottom_center = Vector2(
				screen_size.x / 2,
				screen_size.y - (screen_size.y / 4)  # Center of bottom half
			)
			%Base.position = bottom_center - base_size / 2
			%Tracker.global_position = bottom_center - tracker_size / 2
			
		float_types.BOTTOM_LEFT:
			var bottom_left_center = Vector2(
				screen_size.x / 4,  # Center of left half (screen_size.x/4)
				screen_size.y * 0.75  # Center of bottom half
			)
			%Base.position = bottom_left_center - base_size / 2
			%Tracker.global_position = bottom_left_center - tracker_size / 2
			
		float_types.BOTTOM_RIGHT:
			var bottom_right_center = Vector2(
				screen_size.x * 0.75,  # Center of right half (screen_size.x * 3/4)
				screen_size.y * 0.75  # Center of bottom half
			)
			%Base.position = bottom_right_center - base_size / 2
			%Tracker.global_position = bottom_right_center - tracker_size / 2
			
			
	
