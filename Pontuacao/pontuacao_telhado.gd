extends Control

@onready var label_pontos: Label = $LabelPontuacao
@onready var botao_continuar: Button = $BotaoContinuar

func _ready() -> void:
	# Recupera a pontuação acumulada do Gerenciador
	var pontos = get_node("../GerenciadorJogo").get_pontuacao()
	label_pontos.text = "Pontuação até agora: " + str(pontos)

	# Conecta o botão
	botao_continuar.pressed.connect(_on_botao_continuar_pressed)

func _on_botao_continuar_pressed() -> void:
	# Avança para o próximo exercício/fase
	get_node("../GerenciadorJogo").avancar_exercicio()
