extends Node

signal item_posicionado_com_sucesso(nome_item, tipo_melhoria)
signal casa_sustentavel_completa

var tem_teto_verde: bool = false
var tem_painel_solar: bool = false
var tem_sistema_chuva: bool = false

# Referência ao player de vídeo
var video_player: VideoStreamPlayer

func _ready():
	# Criar botão
	var botao = Button.new()
	botao.text = "Assistir Vídeo"
	botao.position = Vector2(50, 50)
	add_child(botao)
	botao.connect("pressed", Callable(self, "_on_botao_video_pressed"))

	# Criar VideoStreamPlayer
	video_player = VideoStreamPlayer.new()
	video_player.position = Vector2(200, 100)
	video_player.size = Vector2(640, 360)
	video_player.autoplay = false
	add_child(video_player)

func _on_botao_video_pressed():
	# Carregar vídeo da pasta
	var stream = load("res://EcocityQuestProject/Fotos e Videos/Tutorial04.ogv")
	if stream:
		video_player.stream = stream
		video_player.play()
	else:
		print("Erro: vídeo não encontrado.")

func inicializar_exercicio():
	tem_teto_verde = false
	tem_painel_solar = false
	tem_sistema_chuva = false
	print("Exercício da Casa Ecológica iniciado. Melhore a estrutura!")

func aplicar_melhoria_arquitetura(objeto: String, alvo: String) -> Dictionary:
	if alvo == "telhado_casa":
		if objeto == "teto_jardim_sustentavel" or objeto == "grama_telhado":
			if not tem_teto_verde:
				tem_teto_verde = true
				emit_signal("item_posicionado_com_sucesso", objeto, "isolamento_termico")
				_checar_conclusao()
				return {"sucesso": true, "efeito": "Reduz a temperatura da casa naturalmente!"}
		elif objeto == "placa_fotovoltaica":
			if not tem_painel_solar:
				tem_painel_solar = true
				emit_signal("item_posicionado_com_sucesso", objeto, "energia_limpa")
				_checar_conclusao()
				return {"sucesso": true, "efeito": "Gera energia limpa do sol!"}
		else:
			return {"sucesso": false, "mensagem": "Esse material não traz benefícios ecológicos para o telhado."}
	elif alvo == "calha_quintal":
		if objeto == "cisterna_agua_chuva" or objeto == "barril_captacao":
			if not tem_sistema_chuva:
				tem_sistema_chuva = true
				emit_signal("item_posicionado_com_sucesso", objeto, "reuso_agua")
				_checar_conclusao()
				return {"sucesso": true, "efeito": "Armazena água para regar as plantas!"}
		else:
			return {"sucesso": false, "mensagem": "Isso não ajuda a poupar recursos hídricos."}
	return {"sucesso": false, "mensagem": "Local de posicionamento inválido."}

func _checar_conclusao():
	if tem_teto_verde and tem_painel_solar and tem_sistema_chuva:
		emit_signal("casa_sustentavel_completa")
		if ResourceLoader.exists("res://GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()
