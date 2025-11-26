extends CharacterBody2D

var is_left_pressed: bool = false
var is_right_pressed: bool = false
var vertical_speed: float = 2000.0
var horizontal_speed: float = 100.0

# 경계 변수
var boundary_left: float = -360
var boundary_right: float = 720.0

func _ready() -> void:
	pass

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
	velocity.y = - horizontal_speed
	if is_left_pressed:
		velocity.x = - delta * vertical_speed
	elif is_right_pressed:
		velocity.x = delta * vertical_speed
	move_and_slide()
	
	# 경계 체크 - 플레이어가 허용 범위를 벗어나면 게임 오버
	if position.x < boundary_left or position.x > boundary_right:
		game_over()

	SaveManager.game_data.climb_meter = - global_position.y / 100

func apply_boundaries(left: float, right: float) -> void:
	boundary_left = left
	boundary_right = right
	print("Player boundaries updated: left=", boundary_left, ", right=", boundary_right)

func increase_vertical_speed() -> void:
	vertical_speed *= 1.1

func game_over() -> void:
	get_tree().change_scene_to_file("res://src/ending.tscn")
