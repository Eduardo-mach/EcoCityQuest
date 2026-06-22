extends TextureButton

@onready var tela_video: Control = $"/root/ConserteARua_tscn/TelaVideo"
@onready var video_player: VideoStreamPlayer = tela_video.get_node("VideoStreamPlayer")

func _ready() -> void:
	self.pressed.connect(_on_button_pressed)
	video_player.finished.connect(_on_video_finished)

func _on_button_pressed() -> void:
	tela_video.visible = true
	video_player.stream = load("res://Fotos/Tutorial03.ogv")
	video_player.play()
	GerenciadorAudio.tocar("ajuda")

func _on_video_finished() -> void:
	# Esconde a tela quando o vídeo terminar
	tela_video.visible = false
