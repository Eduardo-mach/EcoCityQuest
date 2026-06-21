extends Control

func _ready():
	# Apenas carrega os dados em segundo plano, sem mexer na interface
	if has_node("/root/GerenciadorJogo"):
		var no_gerenciador = get_node("/root/GerenciadorJogo")
		no_gerenciador.carregar_ranking()
