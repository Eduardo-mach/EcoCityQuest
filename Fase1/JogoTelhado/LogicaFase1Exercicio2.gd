extends Node

signal tocar_narracao(nome_audio)
signal objetivo_concluido(tipo_objetivo)
signal exercicio_finalizado

var telhado_concluido: bool = false

# Agora acessa corretamente os nós
@onready var timer_exercicio: Timer = $TimerExercicio
@onready var timer_label: Label = $TimerExercicio/LabelTimer

func inicializar_exercicio():
	telhado_concluido = false

	timer_exercicio.start(0.5)
	await timer_exercicio.timeout
	emit_signal("tocar_narracao", "audio_intro_f1e2")

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

		timer_exercicio.start(3.0)
		await timer_exercicio.timeout

		if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()

func _on_TimerExercicio_timeout() -> void:
	timer_label.text = "Tempo esgotado!"
