extends Node

# ─── PONTUAÇÕES DA SESSÃO ATUAL ───────────────────────────────────────────────
# Cada minijogo salva sua pontuação aqui antes de avançar para a tela de ranking
var pontos_memoria: int = 0
var pontos_telhado: int = 0
var pontos_rua: int = 0
var pontos_caca_palavras: int = 0

# Aliases de compatibilidade (usados em scripts mais antigos)
var pontos_exercicio1: int:
	get: return pontos_memoria
	set(v): pontos_memoria = v

var pontos_exercicio2: int:
	get: return pontos_caca_palavras
	set(v): pontos_caca_palavras = v

# ─── PONTUAÇÃO TOTAL DA SESSÃO ────────────────────────────────────────────────
func get_pontuacao_total() -> int:
	return pontos_memoria + pontos_telhado + pontos_rua + pontos_caca_palavras

# ─── RESETAR PARA NOVO JOGO ───────────────────────────────────────────────────
func resetar():
	pontos_memoria = 0
	pontos_telhado = 0
	pontos_rua = 0
	pontos_caca_palavras = 0
