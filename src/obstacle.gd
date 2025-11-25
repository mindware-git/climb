extends Area2D

enum ObstacleType {
	OBSTACLE,
	SPEED_VERTICAL,
	SPEED_HORIZONTAL,
	LIFE
}

@export var obstacle_type: ObstacleType = ObstacleType.OBSTACLE
@export var speed: float = 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if obstacle_type == ObstacleType.OBSTACLE:
		$AnimatedSprite2D.animation = "obstacle"
	elif obstacle_type == ObstacleType.SPEED_VERTICAL:
		$AnimatedSprite2D.animation = "speed_vertical"
	elif obstacle_type == ObstacleType.SPEED_HORIZONTAL:
		$AnimatedSprite2D.animation = "speed_horizontal"
	elif obstacle_type == ObstacleType.LIFE:
		$AnimatedSprite2D.animation = "life"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 아래로 떨어지는 movement
	position.y += speed * delta


func _on_body_entered(body: Node2D) -> void:
	# 플레이어와 충돌했을 때
	if body.name == "Player":
		match obstacle_type:
			ObstacleType.OBSTACLE:
				print("장애물과 충돌!")
				call_deferred("game_over")
			ObstacleType.SPEED_VERTICAL:
				print("수직 속도 증가 아이템 획득!")
				body.increase_vertical_speed()
				queue_free()
			ObstacleType.SPEED_HORIZONTAL:
				print("수평 속도 증가 아이템 획득!")
				apply_horizontal_speed_bonus()
				queue_free()
			ObstacleType.LIFE:
				print("생명 아이템 획득!")
				apply_life_bonus()
				queue_free()

func apply_horizontal_speed_bonus() -> void:
	SaveManager.game_data.horizontal_speed *= 1.2
	print("수평 속도 20% 증가! 현재 속도: ", SaveManager.game_data.horizontal_speed)

func apply_life_bonus() -> void:
	print("생명 +1! (추후 구현)")

func game_over() -> void:
		# 여기에 게임 오버 로직 추가 가능
		get_tree().change_scene_to_file("res://src/ending.tscn")
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# 화면 밖으로 나가면 자동 삭제
	queue_free()
