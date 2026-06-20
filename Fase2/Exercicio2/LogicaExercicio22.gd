extends Node

#CAÇA-PALAVRAS
signal palavra_encontrada(palavra)
signal jogo_caca_palavras_concluido

# Lista de palavras
var palavras_escondidas: Array = [
	"PAINEL",
	"SUSTENTABILIDADE",
	"ENERGIA",
	"RENOVAVEL"
]

var palavras_descobertas: Array = []
var tamanho_tabuleiro: int = 12 # Reduzido para não ficar gigante na tela

# Mapeamento de coordenadas (X=Coluna, Y=Linha) para o frontend desenhar 
var mapa_posicoes_palavras: Dictionary = {
	"PAINEL":           {"x": 5, "y": 11, "direcao": "horizontal"},
	"SUSTENTABILIDADE": {"x": 0, "y": 13, "direcao": "horizontal"},
	"ENERGIA":          {"x": 1, "y": 1,  "direcao": "vertical"},
	"RENOVAVEL":        {"x": 1, "y": 6,  "direcao": "horizontal"}
}

func inicializar_exercicio() -> Dictionary:
	palavras_descobertas.clear()
	return {
		"tamanho": tamanho_tabuleiro,
		"palavras_para_achar": palavras_escondidas,
		"mapa": mapa_posicoes_palavras
	}

# Valida quando o aluno arrasta o mouse/dedo sobre as letras
func validar_palavra_selecionada(palavra_tentativa: String) -> bool:
	var palavra_formatada = palavra_tentativa.to_upper().strip_edges()
	
	if palavra_formatada in palavras_escondidas and not palavra_formatada in palavras_descobertas:
		palavras_descobertas.append(palavra_formatada)
		emit_signal("palavra_encontrada", palavra_formatada)
		
		_verificar_fim_do_jogo()
		return true
		
	return false

func _verificar_fim_do_jogo():
	if palavras_descobertas.size() == palavras_escondidas.size():
		emit_signal("jogo_caca_palavras_concluido")
		
		await get_tree().create_timer(2.0).timeout
		
		# Envia o comando final para o GerenciadorJogo salvar o Ranking do aluno
		if ResourceLoader.exists("res://GerenciadorJogo.gd"):
			get_node("/root/GerenciadorJogo").avancar_exercicio()
