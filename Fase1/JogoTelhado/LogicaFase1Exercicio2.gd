extends Node

signal tocar_narracao(nome_audio)
signal objetivo_concluido(tipo_objetivo)
signal exercicio_finalizado

var telhado_concluido: bool = false
var tempo_restante: float = 0.0  # em segundos

@onready var timer_exercicio: Timer = $TimerExercicio
@onready var timer_label: Label = $TimerExercicio/LabelTimer

func _ready() -> void:
	timer_exercicio.timeout.connect(_on_TimerExercicio_timeout)

func inicializar_exercicio():
	telhado_concluido = false

	# Pausa narrativa sem usar o TimerExercicio
	await get_tree().create_timer(0.5).timeout
	emit_signal("tocar_narracao", "audio_intro_f1e2")

	# Inicia contagem regressiva do exercício (3 minutos = 180 segundos)
	iniciar_contagem_exercicio(180)

func iniciar_contagem_exercicio(segundos: int):
	tempo_restante = float(segundos)
	_atualizar_label()
	timer_exercicio.start(0.1)  # dispara a cada 0.1s (décimos de segundo)

func _on_TimerExercicio_timeout() -> void:
	tempo_restante -= 0.1
	if tempo_restante > 0:
		_atualizar_label()
	else:
		timer_label.text = "Tempo esgotado!"
		timer_exercicio.stop()
		emit_signal("exercicio_finalizado")

func _atualizar_label():
	var minutos: float = tempo_restante / 60.0
	timer_label.text = "%.2f" % minutos

func processar_item_arrastado(objeto: String, alvo: String) -> Dictionary:
	if alvo == "telhado":
		if objeto == "placa_solar":
			if not telhado_concluido:
				telhado_concluido = true
				emit_signal("objetivo_concluido", "telhado")
				emit_signal("tocar_narracao", "audio_sucesso_telhado")
				_verificar_fim_do_exercicio()
				return {"sucesso": true, "mensagem": "Telhado concluído com placas solares!"}
		else:
			emit_signal("tocar_narracao", "audio_erro_telhado")
			return {"sucesso": false, "mensagem": "Objeto inválido para o telhado."}

	return {"sucesso": false, "mensagem": "Alvo não reconhecido."}

func _verificar_fim_do_exercicio():
	if telhado_concluido:
		emit_signal("exercicio_finalizado")
		emit_signal("tocar_narracao", "audio_parabens_fase1")

		await get_tree().create_timer(3.0).timeout

		if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()


func _on_timer_exercicio_timeout() -> void:
	pass # Replace with function body.
