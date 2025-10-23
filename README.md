# KubePi

Privacy gateway for Raspberry Pi 5.  
Combines WireGuard, Tor, and Headscale for secure and anonymous network routing.

---

### 🧱 Deployment Plan

> **Objective:**  
> Deploy a Raspberry Pi 5 (8 GB) as a high-privacy, self-contained network gateway that anonymizes, encrypts, and manages all traffic inside your LAN.  
> The Pi hides client identities, controls bandwidth, and switches between Normal, Privacy, and Anonymity modes via a YubiKey.

<div align="center">
    <img src="docs\diagrams\kubepi-deployment.drawio.png" alt="Deployment Diagram" style="width: 100%; height: auto;"/>
</div>

---

### What it does
- Acts as a router/firewall for your LAN  
- Encrypts traffic with WireGuard  
- Routes anonymous mode through Tor  
- Uses Headscale for self-hosted Tailscale control  
- Can switch modes via YubiKey

---

### Status
Early setup phase — docs and configs in progress.

---

### License
Apache 2.0 — see [LICENSE](LICENSE)
