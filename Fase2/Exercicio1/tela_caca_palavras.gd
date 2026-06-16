extends Control

@onready var grid_container = $GridContainer_Matriz
# Arraste o seu Label do tempo para cá ou mude o nome após o $ para bater com o seu
@onready var label_cronometro = $Label_Cronometro 

# Variáveis do Caça-Palavras
const MATRIZ_LETRAS = [
	"E","O","L","I","C","A","B","R",
	"P","A","T","R","E","U","S","O",
	"S","O","L","A","R","M","V","E",
	"Q","W","I","E","C","O","L","A",
	"X","Z","C","A","B","T","E","O",
	"U","F","H","G","K","L","P","X"
]
var palavras_para_achar = ["EOLICA", "REUSO", "SOLAR", "ECO"]
var palavras_descobertas = []
var palavra_atual = ""
var botoes_selecionados = []

# VARIÁVEIS DO CRONÔMETRO (10 minutos = 600 segundos)
var tempo_restante = 420
var jogo_acabou = false

func _ready():
	criar_tabuleiro()
	atualizar_texto_cronometro()
	
	# Conecta o relógio por código para não ter erro
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if jogo_acabou:
		return
		
	if tempo_restante > 0:
		tempo_restante -= 1
		atualizar_texto_cronometro()
	else:
		game_over()

func atualizar_texto_cronometro():
	# Transforma os segundos no formato MM:SS (ex: 09:59)
	var minutos = tempo_restante / 60
	var segundos = tempo_restante % 60
	label_cronometro.text = "%02d:%02d" % [minutos, segundos]

func game_over():
	jogo_acabou = true
	print("O tempo acabou! Game Over!")
	# Aqui você pode travar os botões ou mandar para uma tela de "Tente Novamente"
	for botao in grid_container.get_children():
		if botao is Button:
			botao.disabled = true

# --- RESTO DO SEU CÓDIGO DO CAÇA-PALAVRAS (IGUAL ANTES) ---

func criar_tabuleiro():
	for child in grid_container.get_children():
		child.queue_free()
	for letra in MATRIZ_LETRAS:
		var botao = Button.new()
		botao.text = letra
		botao.custom_minimum_size = Vector2(50, 50)
		botao.add_theme_font_size_override("font_size", 24)
		botao.pressed.connect(_on_letra_pressionada.bind(botao))
		grid_container.add_child(botao)

func _on_letra_pressionada(botao_clicado: Button):
	if jogo_acabou or botao_clicado in botoes_selecionados:
		return
	palavra_atual += botao_clicado.text
	botoes_selecionados.append(botao_clicado)
	botao_clicado.modulate = Color(1, 1, 0)
	verificar_palavra()

func verificar_palavra():
	if palavra_atual in palavras_para_achar:
		if not palavra_atual in palavras_descobertas:
			palavras_descobertas.append(palavra_atual)
			print("Você encontrou a palavra: ", palavra_atual)
			
			# 1. Pinta as letras do tabuleiro de VERDE
			for botao in botoes_selecionados:
				botao.modulate = Color(0, 1, 0)
				botao.disabled = true
			
			# 2. GRIFA / RISCA A PALAVRA NA LISTA VERDE DA ESQUERDA
			# Criamos o caminho procurando pelo nome do nó (ex: $Label_EOLICA)
			var nome_no_lista = "Label_" + palavra_atual
			if has_node(nome_no_lista):
				var label_lista = get_node(nome_no_lista)
				# Muda a cor para um cinza escuro (apagado)
				label_lista.modulate = Color(0.4, 0.4, 0.4) 
				
				# Se o seu nó for um RichTextLabel, podemos meter um risco usando BBCode.
				# Como o Label normal não tem risco nativo, mudar a cor para cinza já dá o efeito de "feito"!
				# Se quiser risco mesmo e ele for RichTextLabel, descomente a linha abaixo:
				# label_lista.text = "[s]" + label_lista.text + "[/s]"
			
			# Limpa o rastreador para a próxima tentativa
			palavra_atual = ""
			botoes_selecionados.clear()
			
			# Verifica se ganhou o jogo
			if palavras_descobertas.size() == palavras_para_achar.size():
				ganhou_jogo()
	else:
		if palavra_atual.length() >= 7: 
			limpar_selecao_errada()

func limpar_selecao_errada():
	for botao in botoes_selecionados:
		if not botao.disabled:
			botao.modulate = Color(1, 1, 1)
	palavra_atual = ""
	botoes_selecionados.clear()

func ganhou_jogo():
	jogo_acabou = true
	print("Parabéns! Você encontrou todas as palavras!")
