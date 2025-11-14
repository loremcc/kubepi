#!/bin/bash


# Va aggiunta la configurazione OS del vnc , etc


# [Download dei modelli]
# 
# "phi3:3.8b"         -> Ideale per ragionamento complesso, analisi dati, debug e generazione di script Python. 
#                        Perfetto per nodi di calcolo, analisi finanziaria o multi-step reasoning.
#
# "mistral:7b"        -> Ottimo per ragionamento step-by-step, spiegazioni testuali, consigli e report. 
#                        Utile per agenti che devono combinare più task o dare sintesi leggibili.
#
# "qwen2.5-coder:1.5b" -> Specializzato in generazione di codice, snippet Python o script automatizzati. 
#                         Ideale per nodi di input/output dati, esecuzione calcoli o trasformazioni su file CSV/JSON.
#
# "llama3.1:8b"        -> General-purpose: chat, spiegazioni, dialoghi multi-turn. 
#                         Utile quando serve un modello versatile per testo naturale o consigli.

MODELS=(
  "phi3:3.8b"
  "mistral:7b"
  "qwen2.5-coder:1.5b"
  "llama3.1:8b"
)


DOCKER_COMPOSE_FILE="ollama-suite.compose.yaml"

for MODEL in "${MODELS[@]}"; do
    echo "Pulling model: $MODEL ..."
    docker compose -f "$DOCKER_COMPOSE_FILE" exec ollama ollama pull "$MODEL"
    echo "Finished pulling $MODEL"
    echo ""
done

