extends Node2D

# TODOS:
# 점점 좁아지는 건물
# 저녁이 되면 장애물이 안보임
# 난이도에 맞는 장애물 생성(json으로 관리)
# 아이템이 먹으려고 보면 뭔가 짜증나게 변경되는 거
# 아이템이 좋아보였는데 알고보니 구린것등 어이없는 요소들 넣자.
# 나중에는 직접 건물을 지어서 올라가는걸로 하자.
# 장애물 피하는거 말고도 다른 게임 모드 추가

var obstacle_scene = preload("res://src/obstacle.tscn")
var spawn_positions := [90.0, 180.0, 360.0, 540.0, 630.0] # 5개 스폰 위치
var current_interval: float = 5.0

func get_random_obstacle_type() -> int:
	return randi() % 4 # 0: OBSTACLE, 1: SPEED_VERTICAL, 2: SPEED_HORIZONTAL, 3: LIFE

# 점수에 따른 스폰 간격 계산
func get_spawn_interval() -> float:
	var score = SaveManager.game_data.running_time
	
	if score <= 10:
		return 5.0
	elif score <= 30:
		return 4.0
	elif score <= 60:
		return 3.0
	elif score <= 100:
		return 2.0
	else:
		return 1.0

var spawn_timer: float = 0.0

func _ready() -> void:
	SaveManager.game_data.running_time = 0
	$CanvasLayer/ScoreLabel.text = "Score: %d" % SaveManager.game_data.running_time
	
	# 배경 스크롤 속도에 전역 속도 적용
	# $Parallax2D.autoscroll = Vector2(0, 50 * SaveManager.game_data.horizontal_speed)

func _process(delta: float) -> void:
	# 스폰 타이머 업데이트
	spawn_timer += delta
	
	# 스폰 간격에 도달하면 장애물 생성
	if spawn_timer >= current_interval:
		spawn_timer = 0.0
		
		# 랜덤 스폰 위치 선택 (5개 위치 중 하나)
		var random_x = spawn_positions[randi() % spawn_positions.size()]
		var spawn_position = Vector2(random_x, 0)
		
		# 방해물 생성
		var obstacle = obstacle_scene.instantiate()
		obstacle.global_position = spawn_position
		obstacle.obstacle_type = get_random_obstacle_type() # 랜덤 타입 설정
		add_child(obstacle)

func _on_timer_timeout() -> void:
	SaveManager.game_data.running_time += 1
	$CanvasLayer/ScoreLabel.text = "Score: %d" % SaveManager.game_data.running_time
	current_interval = get_spawn_interval()
