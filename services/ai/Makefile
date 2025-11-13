# ============================================
# 🧠 Ollama Suite Makefile
# Gestione professionale dello stack AI via Docker Compose
# ============================================

# ==== CONFIGURAZIONE ====
COMPOSE_FILE := ollama-suite.compose.yaml
PROJECT_NAME := ollama-suite
DEFAULT_MODEL := llama3.1

# ==== COLORI OUTPUT ====
GREEN := \033[1;32m
YELLOW := \033[1;33m
BLUE := \033[1;34m
RED := \033[1;31m
RESET := \033[0m

# ==== MACRO ====
DOCKER_COMPOSE := docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE)

# ============================================
# 🔧 COMANDI BASE
# ============================================

.PHONY: up down restart build pull ps logs status shell-ollama shell-webui clean init model help

## Avvia tutti i servizi in background
up:
	@echo "$(GREEN)🚀 Avvio di Ollama Suite...$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@$(MAKE) status

## Arresta e rimuove i container
down:
	@echo "$(YELLOW)🛑 Arresto dei container...$(RESET)"
	@$(DOCKER_COMPOSE) down

## Ricostruisce le immagini personalizzate
build:
	@echo "$(BLUE)🔧 Build delle immagini custom...$(RESET)"
	@$(DOCKER_COMPOSE) build

## Aggiorna tutte le immagini dal registry
pull:
	@echo "$(BLUE)⬇️  Pull delle ultime immagini...$(RESET)"
	@$(DOCKER_COMPOSE) pull

## Riavvia lo stack
restart:
	@echo "$(YELLOW)♻️  Riavvio dell’ambiente...$(RESET)"
	@$(MAKE) down
	@$(MAKE) up

## Mostra i log in tempo reale
logs:
	@$(DOCKER_COMPOSE) logs -f --tail=50

## Mostra stato container
ps status:
	@$(DOCKER_COMPOSE) ps

# ============================================
# 🧠 UTILITY E SHELL
# ============================================

## Entra nel container Ollama
shell-ollama:
	@echo "$(GREEN)🔍 Entrando nel container Ollama...$(RESET)"
	@$(DOCKER_COMPOSE) exec ollama bash || echo "❌ Container non in esecuzione."

## Entra nel container WebUI
shell-webui:
	@echo "$(GREEN)🌐 Entrando nel container WebUI...$(RESET)"
	@$(DOCKER_COMPOSE) exec open-webui bash || echo "❌ Container non in esecuzione."

## Pulizia completa (container + volumi + immagini)
clean:
	@echo "$(RED)🧹 Pulizia completa di Ollama Suite...$(RESET)"
	@$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans

# ============================================
# 🚀 INIT E SETUP
# ============================================

## Inizializza Ollama Suite (pull modello, verifica servizi)
init: up model healthcheck

## Scarica un modello Ollama
model:
	@echo "$(BLUE)📦 Scarico modello predefinito: $(DEFAULT_MODEL)...$(RESET)"
	@$(DOCKER_COMPOSE) exec ollama ollama pull $(DEFAULT_MODEL) || \
	  echo "$(YELLOW)⚠️ Assicurati che il container 'ollama' sia attivo.$(RESET)"

## Controlla la salute dei servizi
healthcheck:
	@echo "$(GREEN)🔍 Verifica stato dei servizi...$(RESET)"
	@$(DOCKER_COMPOSE) ps
	@echo "$(BLUE)🌐 Test API Ollama...$(RESET)"
	@curl -s http://localhost:11434/api/tags >/dev/null \
	  && echo "$(GREEN)✅ Ollama API raggiungibile.$(RESET)" \
	  || echo "$(RED)❌ Ollama API non raggiungibile.$(RESET)"
	@echo "$(BLUE)🌐 Test WebUI...$(RESET)"
	@curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200" \
	  && echo "$(GREEN)✅ WebUI attiva su http://localhost:3000$(RESET)" \
	  || echo "$(YELLOW)⚠️ WebUI non ancora pronta.$(RESET)"

# ============================================
# 📘 HELP
# ============================================

help:
	@echo ""
	@echo "$(BLUE)🧠  Makefile — Ollama Suite Management$(RESET)"
	@echo "─────────────────────────────────────────────"
	@echo "$(GREEN)Comandi principali:$(RESET)"
	@echo "  make up           → Avvia i servizi in background"
	@echo "  make down         → Ferma e rimuove i container"
	@echo "  make restart      → Riavvia l’intero stack"
	@echo "  make build        → Ricostruisce immagini personalizzate"
	@echo "  make pull         → Aggiorna immagini Docker"
	@echo "  make logs         → Mostra i log in tempo reale"
	@echo "  make ps           → Mostra lo stato dei container"
	@echo ""
	@echo "$(GREEN)Utility:$(RESET)"
	@echo "  make shell-ollama → Entra nel container Ollama"
	@echo "  make shell-webui  → Entra nel container WebUI"
	@echo "  make clean        → Rimuove container, volumi e immagini"
	@echo ""
	@echo "$(GREEN)Setup & diagnostica:$(RESET)"
	@echo "  make init         → Avvia e scarica modello base"
	@echo "  make model        → Scarica un modello specifico (DEFAULT_MODEL)"
	@echo "  make healthcheck  → Test di salute per API e UI"
	@echo ""