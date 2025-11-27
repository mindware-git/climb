extends Node2D

# TODOS:
# 실제로 카메라가 움직이게 만들자. (왜냐하면 각 객체가 이동하면 뭔까 끊기는듯한 느낌이 난다.)
# 물체 중점 좌표계를 사용하자. 즉 10m에 벽돌이 생기면 벽돌의 중점이 10m라는것.
# 이렇게 되면 그냥 y좌표계를 만들면 된다.

# map.json
# player_boundaries는 즉시 적용임. -> X 이것 역시 8meter 이후.
# obstacles 는 meter + 8 meter이후에 적용되는거임.

# 점점 좁아지는 건물
# 저녁이 되면 장애물이 안보임

# 아이템이 먹으려고 보면 뭔가 짜증나게 변경되는 거
# 아이템이 좋아보였는데 알고보니 구린것등 어이없는 요소들 넣자.
# 나중에는 직접 건물을 지어서 올라가는걸로 하자.
# 장애물 피하는거 말고도 다른 게임 모드 추가
# 기본은 1초당 1m == (100 px)
# 즉 건물은 100px짜리여야함.

var entity_scene = preload("res://src/entity/entity.tscn")
var current_interval: float = 5.0

# Map data variables
var map_data: Dictionary = {}
var current_map_index: int = 0
var last_processed_meter: int = -1

var boundary_left: float = -360.0
var boundary_right: float = 360.0

# 지연된 boundary 적용을 위한 Dictionary (meter를 키로 사용)
var pending_boundaries: Dictionary = {}

func load_map_data() -> void:
	var file = FileAccess.open("res://assets/map.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		if parse_result == OK:
			map_data = json.data
			print("Map data loaded successfully!")
		else:
			print("Error parsing map.json: ", parse_result)
	else:
		print("Error loading map.json file")

func get_current_map_data() -> Dictionary:
	if not map_data.has("maps") or map_data["maps"].is_empty():
		return {}
	var maps = map_data["maps"]
	
	# 배열 범위 확인 추가
	if current_map_index >= maps.size():
		return {}
	
	var map_meter = maps[current_map_index]["meter"]
	if map_meter == last_processed_meter:
		var map = maps[current_map_index]
		current_map_index += 1
		return map
	return {}

func spawn_obstacles_from_map(data: Dictionary) -> void:
	if not data.has("obstacles"):
		return
	
	var obstacles = data["obstacles"]
	var current_meter = data["meter"]
	for obstacle_data in obstacles:
		var obstacle = entity_scene.instantiate()
		obstacle.global_position = Vector2(obstacle_data["position"], (current_meter + 8) * -SaveManager.PIXEL_PER_METER)
		obstacle.obstacle_type = obstacle_data["type"]

		if obstacle_data.has("speed"):
			obstacle.speed = obstacle_data["speed"]

		$Obstacle.add_child(obstacle)

func apply_player_boundaries(data: Dictionary) -> void:
	if not data.has("player_boundaries"):
		return
	
	var boundaries = data["player_boundaries"]
	var player = get_node_or_null("Player")
	if player:
		player.apply_boundaries(boundaries["left"], boundaries["right"])
	boundary_left = boundaries["left"]
	boundary_right = boundaries["right"]

# 지연된 boundary 적용 예약
func schedule_boundary_apply(boundaries: Dictionary, apply_meter: int) -> void:
	pending_boundaries[apply_meter] = boundaries

# 지연된 boundary 적용 확인 및 실행
func apply_player_pending_boundaries(current_meter: int) -> void:
	# 적용해야 할 meter 키들 찾기
	var meters_to_apply: Array[int] = []
	for meter in pending_boundaries.keys():
		if current_meter >= meter:
			meters_to_apply.append(meter)
	
	# 적용하고 삭제
	for meter in meters_to_apply:
		apply_player_boundaries({"player_boundaries": pending_boundaries[meter]})
		pending_boundaries.erase(meter)

func _ready() -> void:
	SaveManager.game_data = GameData.new()
	$CanvasLayer/ScoreLabel.text = "Score: %d" % SaveManager.game_data.running_time
	
	# 맵 데이터 로드
	load_map_data()

	for i in range(16):
		spawn_new_block_row(-i)

func _process(_delta: float) -> void:
	var current_meter = int(SaveManager.game_data.climb_meter)
	
	
	if current_meter != last_processed_meter:
		apply_player_pending_boundaries(current_meter)
		last_processed_meter = current_meter
		var current_map = get_current_map_data()
		if not current_map.is_empty():
			if current_map.has("player_boundaries"):
				# 즉시 적용 대신 8m 후에 적용 예약
				var boundaries = current_map["player_boundaries"]
				schedule_boundary_apply(boundaries, current_map["meter"] + 8)
				# boundary_left, boundary_right는 즉시 업데이트 (건물 스폰용)
				boundary_left = boundaries["left"]
				boundary_right = boundaries["right"]
			if current_map.has("obstacles"):
				spawn_obstacles_from_map(current_map)
		spawn_new_block_row(current_meter)

func spawn_new_block_row(meter: int) -> void:
	# Spawn 8 meter ahead
	var block_mid = boundary_left + 50
	while block_mid + 50 < boundary_right:
		var block = entity_scene.instantiate()
		block.global_position = Vector2(block_mid, (meter + 8) * -SaveManager.PIXEL_PER_METER)
		$Building.add_child(block)
		block_mid += 100
	block_mid = boundary_right - 50
	var block_last = entity_scene.instantiate()
	block_last.global_position = Vector2(block_mid, (meter + 8) * -SaveManager.PIXEL_PER_METER)
	$Building.add_child(block_last)

func _on_timer_timeout() -> void:
	SaveManager.game_data.running_time += 1
	$CanvasLayer/ScoreLabel.text = "Score: %d" % SaveManager.game_data.running_time
	$CanvasLayer/MeterLabel.text = "Meter: %f" % SaveManager.game_data.climb_meter
	print(SaveManager.game_data.climb_meter)
