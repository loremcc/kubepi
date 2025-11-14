# Docker Setup for Ollama + Open-WebUI

This repository contains a Docker Compose setup for running **Ollama** (AI backend), **Open-WebUI** (web interface), **Caddy** (reverse proxy), a **Port Tunneling Router**, and **No-IP Dynamic DNS** in a GPU-accelerated, persistent, and secure environment.

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
  * Exposes port `11434`
  * Auto-restarts (`unless-stopped`)
  * Environment variables:

    * `NVIDIA_VISIBLE_DEVICES=all`
    * `NVIDIA_DRIVER_CAPABILITIES=compute,utility`

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

---

### 4. Port Tunneling Router

* **Description:** Provides secure remote access to internal Docker services.
* **Configuration Highlights:**

  * Docker image: customizable tunneling solution (e.g., `linuxserver/wireguard` or `localtunnel`)
  * Maps internal ports to an external tunnel port
  * Allows secure remote connections without exposing all internal services
  * Depends on Caddy to ensure services are up before tunneling starts
  * Auto-restarts (`unless-stopped`)

---

### 5. No-IP Dynamic DNS

* **Description:** Maps a hostname to a static external IP via the No-IP dashboard.
* **Hostname:** `fucini.onthewifi.com`
* **Purpose:** Provides external access to your network or Docker services using a stable domain name.
* **Notes:** The IP is static and set via the dashboard, not dynamically updated.
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

---

## TL;DR

* **Ollama**: AI brain (GPU-powered)
* **Open-WebUI**: User-friendly web interface
* **Caddy**: Serves Open-WebUI securely with HTTPS
* **Port Tunnel**: Enables secure remote access to internal services
* **No-IP**: Maps `fucini.onthewifi.com` to a static external IP set via dashboard

**Startup flow:** Ollama → Open-WebUI → Caddy → Port Tunnel → No-IP

This setup ensures a GPU-accelerated AI service with a persistent, secure, accessible web interface, and external access through a static DNS entry.
