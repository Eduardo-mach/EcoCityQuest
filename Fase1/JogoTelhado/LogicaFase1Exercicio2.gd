extends Node

signal tocar_narracao(nome_audio)
signal objetivo_concluido(tipo_objetivo)
signal exercicio_finalizado

var telhado_concluido: bool = false

var timer_exercicio: Timer
var timer_label: Label
var tempo_restante: int = 10  # segundos de duração do exercício

func _ready() -> void:
	# Criar Timer
	timer_exercicio = Timer.new()
	timer_exercicio.wait_time = 1.0
	timer_exercicio.one_shot = false
	add_child(timer_exercicio)

	# Conectar sinal timeout
	timer_exercicio.timeout.connect(_on_TimerExercicio_timeout)

	# Criar Label para mostrar tempo
	timer_label = Label.new()
	timer_label.text = formatar_tempo(tempo_restante)
	add_child(timer_label)

func inicializar_exercicio():
	telhado_concluido = false
	tempo_restante = 10  # reinicia o cronômetro
	timer_label.text = formatar_tempo(tempo_restante)
	timer_exercicio.start()

	# Pequeno atraso antes da narração inicial
	await get_tree().create_timer(0.5).timeout
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
		# A navegação é tratada pelo Fase1Exercicio2.gd ao receber o sinal exercicio_finalizado

func _on_TimerExercicio_timeout() -> void:
	tempo_restante -= 1
	if tempo_restante > 0:
		timer_label.text = formatar_tempo(tempo_restante)
	else:
		timer_exercicio.stop()
		timer_label.text = "Tempo esgotado!"
		emit_signal("exercicio_finalizado")

func formatar_tempo(segundos: int) -> String:
	var minutos = int(segundos / 60)
	var seg = int(segundos % 60)
	return str(minutos).pad_zeros(2) + ":" + str(seg).pad_zeros(2)
