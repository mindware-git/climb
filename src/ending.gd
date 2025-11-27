extends Node2D

func _ready() -> void:
	# SaveManager에서 게임 데이터 로드
	SaveManager.format_check()
	var running_time = SaveManager.game_data.running_time
	var climb_meter = SaveManager.game_data.climb_meter
	
	# UI 요소들 설정
	$CanvasLayer/VBoxContainer/TitleLabel.text = "Game Over"
	$CanvasLayer/VBoxContainer/ScoreLabel.text = "생존 시간: %s\n도달 거리: %.1fm" % [format_time(running_time), climb_meter]
	$CanvasLayer/VBoxContainer/Button.text = "새 게임"
	
	# UI 스타일 개선
	setup_ui_styles()
	
	# VBoxContainer 간격 및 크기 설정
	$CanvasLayer/VBoxContainer.add_theme_constant_override("separation", 30)
	$CanvasLayer/VBoxContainer.set_custom_minimum_size(Vector2(400, 300))

func setup_ui_styles():
	# 제목 레이블 스타일
	$CanvasLayer/VBoxContainer/TitleLabel.add_theme_font_size_override("font_size", 64)
	$CanvasLayer/VBoxContainer/TitleLabel.add_theme_color_override("font_color", Color.RED)
	$CanvasLayer/VBoxContainer/TitleLabel.add_theme_constant_override("outline_size", 2)
	$CanvasLayer/VBoxContainer/TitleLabel.add_theme_color_override("font_outline_color", Color.WHITE)
	
	# 스코어 레이블 스타일
	$CanvasLayer/VBoxContainer/ScoreLabel.add_theme_font_size_override("font_size", 32)
	$CanvasLayer/VBoxContainer/ScoreLabel.add_theme_color_override("font_color", Color.WHITE)
	$CanvasLayer/VBoxContainer/ScoreLabel.add_theme_constant_override("outline_size", 1)
	$CanvasLayer/VBoxContainer/ScoreLabel.add_theme_color_override("font_outline_color", Color.BLACK)
	
	# 버튼 스타일
	$CanvasLayer/VBoxContainer/Button.add_theme_font_size_override("font_size", 28)
	$CanvasLayer/VBoxContainer/Button.set_custom_minimum_size(Vector2(200, 60))
	
	# 버튼에 여백 추가
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color(0.2, 0.6, 0.2) # 녹색 배경
	button_style.border_width_left = 3
	button_style.border_width_right = 3
	button_style.border_width_top = 3
	button_style.border_width_bottom = 3
	button_style.border_color = Color.WHITE
	button_style.corner_radius_top_left = 10
	button_style.corner_radius_top_right = 10
	button_style.corner_radius_bottom_left = 10
	button_style.corner_radius_bottom_right = 10
	button_style.content_margin_left = 20
	button_style.content_margin_right = 20
	button_style.content_margin_top = 15
	button_style.content_margin_bottom = 15
	
	$CanvasLayer/VBoxContainer/Button.add_theme_stylebox_override("normal", button_style)
	
	# 버튼 호버 스타일
	var hover_style = button_style.duplicate()
	hover_style.bg_color = Color(0.3, 0.8, 0.3) # 밝은 녹색
	$CanvasLayer/VBoxContainer/Button.add_theme_stylebox_override("hover", hover_style)
	
	# 버튼 눌림 스타일
	var pressed_style = button_style.duplicate()
	pressed_style.bg_color = Color(0.1, 0.4, 0.1) # 어두운 녹색
	$CanvasLayer/VBoxContainer/Button.add_theme_stylebox_override("pressed", pressed_style)
	

func _on_button_pressed() -> void:
	# 저장 파일 삭제
	SaveManager.remove_save_file()
	# 메인 씬으로 이동
	get_tree().change_scene_to_file("res://main.tscn")

# 초를 "MM:SS" 형식으로 변환하는 함수
func format_time(seconds: int) -> String:
	@warning_ignore("integer_division")
	var minutes = int(seconds / 60)
	var secs = seconds % 60
	return "%02d:%02d" % [minutes, secs]
