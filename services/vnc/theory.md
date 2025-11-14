# Documentazione: Unit Service `vnc-boot.service`

## Cos'è un Unit Service

Uno **unit service** è un servizio di sistema che viene avviato automaticamente al **boot del sistema operativo**. È chiamato "unit" perché rappresenta una singola unità di funzionalità del sistema. Questi servizi sono gestiti da `systemd` e consentono di automatizzare l'avvio e la gestione di applicazioni e servizi di sistema.

## Protocollo VNC

Il **protocollo VNC (Virtual Network Computing)** permette di controllare graficamente un computer remoto tramite rete. A differenza di SSH, che offre solo un'interfaccia testuale, VNC consente di interagire con l'ambiente desktop completo come se si fosse seduti davanti al computer.

Abbiamo utilizzato VNC in questo progetto per:

* Controllare il sistema in modo visivo, oltre che tramite SSH.
* Accedere a applicazioni grafiche remote senza essere fisicamente davanti al dispositivo.
* Verificare e monitorare l'interfaccia grafica del sistema durante l'esecuzione di servizi e applicazioni.

## Esempio: `vnc-boot.service`

Il file `vnc-boot.service`, presente nella directory:

```
/home/chilledpanda/Personal/progetti/kubepi/services/vnc/
```

è un esempio di unit service utilizzato per avviare il servizio **VNC** al boot del sistema operativo.

### Posizionamento del file

Per essere avviato automaticamente al boot, il file deve essere copiato nella directory dei servizi di sistema:

```
/etc/systemd/system/
```

con estensione `.service`.

### Contenuto del file `vnc-boot.service`

```ini
[Unit]
Description=VNC Boot Service
After=network.target

[Service]
ExecStart=/usr/bin/vncserver -geometry 1024x768 -depth 24 :1
Restart=always

[Install]
WantedBy=multi-user.target
```

#### Spiegazione delle sezioni:

* `[Unit]`

  * `Description`: Descrizione del servizio.
  * `After=network.target`: Il servizio deve essere avviato **dopo** che la rete è stata caricata.

* `[Service]`

  * `ExecStart`: Comando da eseguire per avviare il servizio VNC.
  * `Restart=always`: Il servizio deve essere riavviato automaticamente in caso di arresto o crash.

* `[Install]`

  * `WantedBy=multi-user.target`: Il servizio viene avviato in modalità multi-user, prima del login.

## Configurazione e Abilitazione

Dopo aver creato o copiato il file in `/etc/systemd/system/`, eseguire i seguenti comandi per abilitare e avviare il servizio:

```bash
# Ricaricare i file di systemd
sudo systemctl daemon-reload

# Abilitare il servizio al boot
sudo systemctl enable vnc-boot.service

# Avviare subito il servizio
sudo systemctl start vnc-boot.service

# Verificare lo stato del servizio
sudo systemctl status vnc-boot.service
```

## Sintesi

L'unit service `vnc-boot.service`:

* È un servizio di sistema che avvia VNC automaticamente al boot.
* Permette il controllo visivo del sistema tramite il protocollo VNC, oltre all'accesso testuale tramite SSH.
* Deve essere presente in `/etc/systemd/system/`.
* È configurato per partire dopo il caricamento della rete e per riavviarsi automaticamente se necessario.
* Consente agli utenti di accedere alla console remota senza dover effettuare il login locale.
