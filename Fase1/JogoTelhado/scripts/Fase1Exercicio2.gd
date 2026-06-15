extends Control

@onready var logica: Node = $LogicaExercicio
@onready var item_placa: Control = $ItemPlacaSolar
@onready var item_entulho: Control = $ItemEntulho
@onready var drop_telhado: Control = $DropTelhado
@onready var botao_voltar: TextureButton = $BotaoVoltar
@onready var botao_ajuda: TextureButton = $BotaoAjuda

func _ready() -> void:
	logica.tocar_narracao.connect(_on_tocar_narracao)
	logica.objetivo_concluido.connect(_on_objetivo_concluido)
	logica.exercicio_finalizado.connect(_on_exercicio_finalizado)

	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_ajuda.pressed.connect(_on_botao_ajuda_pressed)

	logica.inicializar_exercicio()

func _on_tocar_narracao(nome_audio: String) -> void:
	GerenciadorAudio.tocar(nome_audio)

func _on_objetivo_concluido(tipo: String) -> void:
	if tipo == "telhado":
		# Some com o entulho, já que a opção correta foi escolhida
		item_entulho.visible = false

func _on_exercicio_finalizado() -> void:
	print("Exercício Fase 1 - Exercício 2 concluído!")

func _on_botao_voltar_pressed() -> void:
	if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
		get_node("/root/GerenciadorJogo").voltar_exercicio()
		

func processar_item_arrastado(nome_objeto: String, nome_alvo: String) -> Dictionary:
	if nome_objeto == "placa_solar" and nome_alvo == "telhado":
		return {"sucesso": true}
	elif nome_objeto == "entulho" and nome_alvo == "telhado":
		return {"sucesso": false}
	else:
		return {"sucesso": false}


func _on_botao_ajuda_pressed() -> void:
	GerenciadorAudio.tocar("audio_intro_f1e2")
