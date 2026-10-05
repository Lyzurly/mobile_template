extends CanvasLayer

@warning_ignore_start("unused_signal")
signal joystick_single_output(delta:float,pressured_direction:Vector2)

var mobile_input_config: Mobile_Input_Config = load("res://Mobile_Input/Mobile_Input_Config.tres")

var input_array: Array[PackedScene] = [
	load("res://touch_joystick.tscn"),
]

func _ready() -> void:
	setup_joystick()
	
func setup_joystick() -> void:	
	match mobile_input_config.joystick_visibilities:
		mobile_input_config.joystick_visibilities.ON_TOUCH:
			%Touch_Joystick.visibility = %Touch_Joystick.visibilities.TOUCH
		mobile_input_config.joystick_visibilities.ALWAYS:
			%Touch_Joystick.visibility = %Touch_Joystick.visibilities.ALWAYS
		mobile_input_config.joystick_visibilities.NEVER:
			%Touch_Joystick.visibility = %Touch_Joystick.visibilities.NEVER
	
	%Touch_Joystick.set_visibility(false)
			
	match mobile_input_config.joystick_type:
		mobile_input_config.joystick_types.FLOATING:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.FULL
		mobile_input_config.joystick_types.FLOATING_BOTTOM:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.BOTTOM
		mobile_input_config.joystick_types.FLOATING_BOTTOM_LEFT:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.BOTTOM_LEFT
		mobile_input_config.joystick_types.FLOATING_BOTTOM_RIGHT:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.BOTTOM_RIGHT
		mobile_input_config.joystick_types.FLOATING_DYNAMIC:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.base_mode = %Touch_Joystick.base_modes.DYNAMIC
		
		#joystick_types.FIXED_CUSTOM_SINGLE:
			#%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FIXED
			#%Touch_Joystick.fixed_type = %Touch_Joystick.fixed_types.CUSTOM
		
	%Touch_Joystick.center_joystick_to_screen()
			
