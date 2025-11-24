extends CharacterBody2D

var is_left_pressed: bool = false
var is_right_pressed: bool = false
@export var speed: float = 200.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var x = event.position.x
		var screen_half = get_viewport().get_visible_rect().size.x / 2

		if event.pressed:
			if x < screen_half:
				is_left_pressed = true
				is_right_pressed = false
			else:
				is_right_pressed = true
				is_left_pressed = false
		else:
			is_left_pressed = false
			is_right_pressed = false

func _process(delta: float) -> void:
	velocity.x = 0

	if is_left_pressed:
		velocity.x = - speed
	elif is_right_pressed:
		velocity.x = speed

	move_and_slide()
