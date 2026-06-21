extends Node
# JOGO DE ARRASTAR - FASE 1 EXERCÍCIO 2 (Termine o Telhado)

signal tocar_narracao(nome_audio)
signal objetivo_concluido(tipo_objetivo)
signal exercicio_finalizado

var telhado_concluido: bool = false
var tempo_restante: int = 0

@onready var timer_exercicio: Timer = $TimerExercicio
@onready var timer_label: Label = $TimerExercicio/LabelTimer

func _ready():
	# Conecta o sinal timeout ao método
	timer_exercicio.timeout.connect(_on_TimerExercicio_timeout)

func inicializar_exercicio():
	telhado_concluido = false

	tempo_restante = 180
	_atualizar_label()

	# TimerExercicio só para contagem regressiva
	timer_exercicio.wait_time = 1.0
	timer_exercicio.one_shot = false
	timer_exercicio.start()

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

		# Pausa narrativa sem mexer no TimerExercicio
		await get_tree().create_timer(3.0).timeout

		if ResourceLoader.exists("res://scripts/GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()



func _on_TimerExercicio_timeout() -> void:
	tempo_restante -= 1
	if tempo_restante >= 0:
		_atualizar_label()
	else:
		timer_exercicio.stop()
		timer_label.text = "Tempo esgotado!"
		emit_signal("exercicio_finalizado")

# Função auxiliar para formatar minutos:segundos
func _atualizar_label():
	var minutos = tempo_restante / 60
	var segundos = tempo_restante % 60
	timer_label.text = str(minutos) + ":" + str(segundos).pad_zeros(2)
