extends CharacterBody2D

var is_left_pressed: bool = false
var is_right_pressed: bool = false
@export var speed: float = 4000.0
var vertical_speed: float = 1.0

# 경계 상수
const BOUNDARY_LEFT = 90.0
const BOUNDARY_RIGHT = 630.0

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
	velocity *= delta * vertical_speed
	move_and_slide()
	
	# 경계 체크 - 플레이어가 허용 범위를 벗어나면 게임 오버
	if position.x < BOUNDARY_LEFT or position.x > BOUNDARY_RIGHT:
		game_over()

func increase_vertical_speed() -> void:
	vertical_speed += 1.0

func game_over() -> void:
	get_tree().change_scene_to_file("res://src/ending.tscn")
