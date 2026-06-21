extends Control
# Script genérico para itens arrastáveis (placa solar, entulho, etc.)

@export var nome_objeto: String = ""       # ex: "placa_solar" ou "entulho"
@export var nome_alvo: String = "telhado"  # nome do alvo que este item tenta atingir

var arrastando: bool = false
var posicao_original: Vector2
var offset_clique: Vector2 = Vector2.ZERO

func _ready() -> void:
	posicao_original = position
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				arrastando = true
				offset_clique = get_global_mouse_position() - global_position
				get_parent().move_child(self, get_parent().get_child_count() - 1)
			else:
				if arrastando:
					arrastando = false
					_soltar_item()

	elif event is InputEventMouseMotion:
		if arrastando:
			global_position = get_global_mouse_position() - offset_clique
			
func _soltar_item() -> void:
	var logica = get_node("/root/JogoTelhado")
	var drop_telhado = get_parent().get_node("DropTelhado")

	var limite_x: float = drop_telhado.size.x / 2
	var limite_y: float = drop_telhado.size.y / 2

	var caiu_no_alvo: bool = abs(global_position.x - drop_telhado.global_position.x) < limite_x \
		and abs(global_position.y - drop_telhado.global_position.y) < limite_y

	if caiu_no_alvo:
		var resultado: Dictionary = logica.processar_item_arrastado(nome_objeto, nome_alvo)
		if resultado["sucesso"]:
			global_position = drop_telhado.global_position
			mouse_filter = Control.MOUSE_FILTER_IGNORE

			# Se o objeto atual for o painel solar, remover o lixo
			if nome_objeto == "placa_solar":
				var lixo = get_parent().get_node_or_null("ItemEntulho")
				if lixo:
					lixo.queue_free()  # remove o nó de lixo da cena
		else:
			position = posicao_original
	else:
		position = posicao_original
