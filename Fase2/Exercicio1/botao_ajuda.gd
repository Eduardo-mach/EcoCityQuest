extends TextureButton

var popup_video: Control
var video_player: VideoStreamPlayer

func _ready() -> void:
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	if not popup_video:
		_criar_popup_video()
	popup_video.visible = true
	video_player.play()
	GerenciadorAudio.tocar("ajuda")

func _criar_popup_video() -> void:
	var root = get_node("/root/CacaPalavras")
	popup_video = Control.new()
	popup_video.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup_video.visible = false
	root.add_child(popup_video)

	var fundo = ColorRect.new()
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.color = Color(0, 0, 0, 0.7)
	popup_video.add_child(fundo)

	var container = CenterContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup_video.add_child(container)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	container.add_child(vbox)

	video_player = VideoStreamPlayer.new()
	video_player.custom_minimum_size = Vector2(800, 450)
	video_player.stream = load("res://assets/Videos/ttutorial3.ogv")
	video_player.finished.connect(_on_video_finished)
	vbox.add_child(video_player)

	var botao_fechar = Button.new()
	botao_fechar.text = "Fechar"
	botao_fechar.custom_minimum_size = Vector2(120, 40)
	botao_fechar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	botao_fechar.pressed.connect(_on_botao_fechar_video_pressed)
	vbox.add_child(botao_fechar)

func _on_botao_fechar_video_pressed() -> void:
	popup_video.visible = false
	video_player.stop()

func _on_video_finished() -> void:
	popup_video.visible = false
