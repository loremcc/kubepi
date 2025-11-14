
# Docker Setup for Ollama + Open-WebUI

This repository contains a Docker Compose setup for running **Ollama** (AI backend), **Open-WebUI** (web interface), **Caddy** (reverse proxy), a **Port Tunneling Router**, and **No-IP Dynamic DNS** in a GPU-accelerated, persistent, and secure environment.  

It provides both a **browser-based interface** and **programmatic API access**, all secured via HTTPS and optional port tunneling.

---

## Overview

The system is composed of five main services:

| Service         | Role                                                    | Ports / URL            |
| --------------- | ------------------------------------------------------- | ---------------------- |
| **Ollama**      | AI backend / model inference engine                     | 11434                  |
| **Open-WebUI**  | Web interface to interact with Ollama                   | 8080                   |
| **Caddy**       | Reverse proxy & HTTPS server for secure web access      | 80 / 443               |
| **Port Tunnel** | Allows remote access to internal services via tunneling | Custom                 |
| **No-IP**       | Maps a hostname to a static external IP via dashboard   | `fucini.onthewifi.com` |

**Workflow:**

```
+--------+       +-------------+       +-------+       +------------+       +---------+
| Ollama | <---> | Open-WebUI  | <---> | Caddy | <---> | Port Tunnel| <---> | No-IP   |
+--------+       +-------------+       +-------+       +------------+       +---------+
(port 11434)      (port 8080)         (ports 80/443)   (custom port)      (DNS)
```

1. Ollama runs AI models and exposes an API.
2. Open-WebUI connects to Ollama to provide a user interface.
3. Caddy serves Open-WebUI securely over HTTP/HTTPS.
4. Port Tunnel allows external devices to securely access services running inside Docker.
5. No-IP maps the hostname `fucini.onthewifi.com` to a static external IP via the dashboard.

---

## Services

### 1. Ollama

* **Description:** AI backend that performs model inference.
* **Configuration Highlights:**
  * Docker image: `ollama/ollama:latest`
  * GPU support via `runtime: nvidia`
  * Persistent volume: `ollama`
  * Exposes port `11434` internally (for API access)
  * Auto-restarts (`unless-stopped`)
  * Environment variables:
    * `NVIDIA_VISIBLE_DEVICES=all`
    * `NVIDIA_DRIVER_CAPABILITIES=compute,utility`
* **Usage:** Can be accessed via API directly or through Open-WebUI.

---

### 2. Open-WebUI

* **Description:** Web interface for interacting with Ollama.
* **Configuration Highlights:**
  * Docker image: `ghcr.io/open-webui/open-webui:main`
  * Persistent volume: `open-webui`
  * Connects to Ollama via `OLLAMA_API_BASE_URL=http://ollama:11434`
  * Depends on Ollama (ensures proper startup order)
  * Exposes port `8080` for browser access
  * Extra host mapping: `host.docker.internal:host-gateway`
  * Auto-restarts (`unless-stopped`)
* **Access:** Visit **[https://fucini.onthewifi.com/](https://fucini.onthewifi.com/)** in your browser to interact with models.

---

### 3. Caddy

* **Description:** Reverse proxy and HTTPS server for Open-WebUI.
* **Configuration Highlights:**
  * Docker image: `caddy:latest`
  * Persistent volumes:
    * `caddy_data` (runtime data, certificates)
    * `caddy_config` (config files)
  * Uses `Caddyfile` for routing and TLS configuration
  * Depends on Open-WebUI (starts after frontend is ready)
  * Exposes standard web ports: 80 (HTTP) and 443 (HTTPS)
  * Auto-restarts (`unless-stopped`)
* **Purpose:** Provides secure HTTPS access, automatic certificate management, and reverse proxy routing.

---

### 4. Port Tunneling Router

* **Description:** Provides secure remote access to internal Docker services.
* **Configuration Highlights:**
  * Docker image: customizable tunneling solution (e.g., `linuxserver/wireguard` or `localtunnel`)
  * Maps internal ports to an external tunnel port
  * Allows secure remote connections without exposing all internal services
  * Depends on Caddy to ensure services are up before tunneling starts
  * Auto-restarts (`unless-stopped`)
* **Use Case:** Access Ollama API externally without opening ports on your router.

---

### 5. No-IP Dynamic DNS

* **Description:** Maps a hostname to a static external IP via the No-IP dashboard.
* **Hostname:** `fucini.onthewifi.com`
* **Purpose:** Provides external access to your network or Docker services using a stable domain name.
* **Notes:** The IP is static and set via the dashboard; no dynamic updates required.
* Auto-restarts (`unless-stopped`)

---

## Volumes

Persistent storage is defined to ensure data and configuration survive container restarts:

| Volume         | Purpose                      |
| -------------- | ---------------------------- |
| `ollama`       | Ollama backend data          |
| `open-webui`   | Open-WebUI data              |
| `caddy_data`   | Runtime data (certificates)  |
| `caddy_config` | Caddy configuration files    |
| `port_tunnel`  | Port tunneling configuration |
| `noip_config`  | No-IP configuration          |

----

## Accessing Services

### Browser (Open-WebUI)

- Open your browser at: **[https://fucini.onthewifi.com/](https://fucini.onthewifi.com/)**
- You get a user-friendly interface to interact with AI models.
- No additional configuration is required; Caddy handles HTTPS and routing automatically.


## Accessing Services

### Browser (Open-WebUI)

- Open your browser at: **[https://fucini.onthewifi.com/](https://fucini.onthewifi.com/)**
- Provides a user-friendly interface to interact with AI models.
- HTTPS and routing handled automatically by Caddy.

### API (Ollama)

- Access the Ollama API directly for programmatic requests.
- Port tunneling allows secure external access without opening internal ports on your router.
- Example `curl` request:

```bash
curl -X POST "http://fucini.onthewifi.com:11434/v1/completions"      -H "Content-Type: application/json"      -d '{
           "model": "llama3.1:8b",
           "prompt": "Scrivi una breve poesia sulla luna",
           "max_tokens": 100
         }'
```

- Example response:

```json
{
  "id":"cmpl-586",
  "object":"text_completion",
  "created":1763055212,
  "model":"llama3.1:8b",
  "system_fingerprint":"fp_ollama",
  "choices":[{"text":"La luna splende tra le stelle,
eterna e silenziosa come un sogno.
I suoi raggi brillano su nostro mare:
la sua bellezza ci avvolge senza fine.","index":0,"finish_reason":"stop"}],
  "usage":{"prompt_tokens":20,"completion_tokens":43,"total_tokens":63}
}
```

💡 **Tips:**
- Always secure port tunneling with authentication to avoid exposing internal services.
- Ensure HTTPS is working via Caddy to protect credentials and API keys.

---

## TL;DR

* **Ollama**: AI brain (GPU-powered)
* **Open-WebUI**: User-friendly web interface
* **Caddy**: Serves Open-WebUI securely with HTTPS
* **Port Tunnel**: Enables secure remote access to internal services
* **No-IP**: Maps `fucini.onthewifi.com` to a static external IP set via dashboard

**Startup flow:** Ollama → Open-WebUI → Caddy → Port Tunnel → No-IP

This setup ensures a GPU-accelerated AI service with a persistent, secure, accessible web interface, and external access through a static DNS entry.

