extends Control

# Puxa o botão com os dois 'R's conforme a sua árvore de nós
@onready var botao_ranking = $Botao_Avancar

# Puxa o nó Linha3 para exibir a pontuação do Exercício 1
@onready var linha_pontuacao = $Pontuacao

func _ready():
	# Garante a conexão do clique do botão para avançar
	botao_ranking.pressed.connect(_on_botao_ranking_pressed)
	
	# Busca no gerenciador global que o Godot já reconhece
	var ranking_global = get_node("/root/GerenciadorRanking")
	
	# Agora sim! Altera o texto da Linha3 com a pontuação salva
	linha_pontuacao.text = "Pontuação: " + str(ranking_global.pontos_exercicio1) + " pts"

func _on_botao_ranking_pressed():
	# Leva o jogador direto para o Caça-Palavras que está na subpasta Exercicio1
	get_tree().change_scene_to_file("res://Fase2/Exercicio1/tela_caca_palavras.tscn")
