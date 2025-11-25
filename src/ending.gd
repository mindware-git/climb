extends Node2D

func _ready() -> void:
	# SaveManager에서 게임 데이터 로드
	SaveManager.format_check()
	var running_time = SaveManager.game_data.running_time
	
	# UI 요소들 설정
	$CanvasLayer/VBoxContainer/TitleLabel.text = "Game Over"
	$CanvasLayer/VBoxContainer/ScoreLabel.text = "생존 시간: %s" % format_time(running_time)
	$CanvasLayer/VBoxContainer/Button.text = "새 게임"
	

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
