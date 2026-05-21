#!/usr/bin/env bash
# =============================================================================
#  install.sh — Provisioning de la VM Debian 12
#  Exécuté automatiquement au premier "vagrant up"
# =============================================================================

set -euo pipefail

# Empêcher les fenêtres interactives de bloquer apt-get
export DEBIAN_FRONTEND=noninteractive

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Provisioning VM Debian 12 (Bookworm)   ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── 1. Mise à jour du système ─────────────────────────────────────────────────
echo "▶ [1/6] Mise à jour du système (cela peut prendre quelques minutes)..."

# Empêcher la mise à jour de grub qui bloque souvent VirtualBox
apt-mark hold grub-pc grub-pc-bin grub2-common grub-common

apt-get update
apt-get upgrade -y

# ── 2. Paquets essentiels ─────────────────────────────────────────────────────
echo "▶ [2/6] Installation des paquets essentiels..."
apt-get install -y \
  curl \
  wget \
  git \
  vim \
  nano \
  htop \
  tree \
  unzip \
  zip \
  net-tools \
  iputils-ping \
  dnsutils \
  build-essential \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  bash-completion \
  man-db \
  sudo \
  nginx

# ── 3. Configuration du fuseau horaire ───────────────────────────────────────
echo "▶ [3/5] Configuration du fuseau horaire (Europe/Paris)..."
timedatectl set-timezone Europe/Paris 2>/dev/null || \
  ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

# ── 4. Configuration de l'environnement utilisateur root ──────────────────
echo "▶ [4/6] Configuration de l'environnement (root)..."

# Alias utiles dans .bashrc de root
cat >> /root/.bashrc << 'EOF'

# ── Alias personnalisés ────────────────────────────────────────
alias ll='ls -alFh --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ports='ss -tulnp'
alias myip='hostname -I'

# Prompt coloré avec nom de la VM pour ROOT (rouge)
export PS1='\[\033[01;31m\]\u@debian-dev\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
EOF

# Dossier workspace propre pour root
mkdir -p /root/workspace
chown -R root:root /root/workspace

# Forcer la connexion en root lors de `vagrant ssh`
echo "exec sudo -i" > /home/vagrant/.bash_profile
chown vagrant:vagrant /home/vagrant/.bash_profile

# ── 5. Message de bienvenue ───────────────────────────────────────────────────
echo "▶ [5/5] Configuration du message de bienvenue..."
cat > /etc/motd << 'EOF'

======================================================================
  ____  _                                            
 | __ )(_) ___ _ ____   _____ _ __  _   _  ___       
 |  _ \| |/ _ \ '_ \ \ / / _ \ '_ \| | | |/ _ \      
 | |_) | |  __/ | | \ V /  __/ | | | |_| |  __/      
 |____/|_|\___|_| |_|\_/ \___|_| |_|\__,_|\___|      
                                                     
  Bienvenue dans le bootcamp devsecops organisé par DIKONGUE SAMUEL
======================================================================

  VM Debian 12 (Bookworm) — Vagrant
  ──────────────────────────────────
  IP privée   : 192.168.56.10
  Workspace   : /root/workspace  (synchronisé avec ./workspace/)
  Projet      : /vagrant         (synchronisé avec le dossier racine)

  Commandes utiles :
    ports      → afficher les ports en écoute
    myip       → afficher les IPs
    ll         → ls amélioré

EOF

# ── 6. Serveur Web Nginx ──────────────────────────────────────────────────────
echo "▶ [6/6] Configuration de Nginx..."

cat > /var/www/html/index.html << 'EOF_NGINX'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bootcamp DevSecOps</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Inter:wght@300;500;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #050505;
            color: #ffffff;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: radial-gradient(circle at 50% 50%, #111 0%, #000 100%);
        }

        /* Abstract Background Elements */
        .glow {
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(0, 255, 170, 0.15) 0%, rgba(0, 0, 0, 0) 70%);
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 0;
            animation: pulse 4s infinite alternate;
        }

        .grid {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                linear-gradient(rgba(0, 255, 170, 0.05) 1px, transparent 1px),
                linear-gradient(90deg, rgba(0, 255, 170, 0.05) 1px, transparent 1px);
            background-size: 40px 40px;
            z-index: 0;
            opacity: 0.5;
            perspective: 1000px;
            transform: rotateX(60deg) translateY(-100px) scale(2);
            animation: moveGrid 15s linear infinite;
        }

        @keyframes moveGrid {
            0% { background-position: 0 0; }
            100% { background-position: 0 40px; }
        }

        @keyframes pulse {
            0% { transform: translate(-50%, -50%) scale(1); opacity: 0.5; }
            100% { transform: translate(-50%, -50%) scale(1.1); opacity: 1; }
        }

        /* Card Container */
        .card {
            background: rgba(20, 20, 20, 0.6);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(0, 255, 170, 0.2);
            border-radius: 24px;
            padding: 3rem 4rem;
            text-align: center;
            z-index: 10;
            max-width: 800px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 40px rgba(0, 255, 170, 0.1);
            animation: float 6s ease-in-out infinite;
            transform-style: preserve-3d;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-15px); }
            100% { transform: translateY(0px); }
        }

        /* Typography */
        h1 {
            font-family: 'Orbitron', sans-serif;
            font-size: 3rem;
            margin-bottom: 1rem;
            background: linear-gradient(90deg, #00ffaa, #00b3ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        h2 {
            font-size: 1.5rem;
            font-weight: 300;
            color: #a0aab5;
            margin-bottom: 2rem;
            letter-spacing: 1px;
        }

        .highlight {
            color: #ffffff;
            font-weight: 700;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
        }

        /* Status Badge */
        .status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(0, 255, 170, 0.1);
            border: 1px solid rgba(0, 255, 170, 0.3);
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-family: 'Orbitron', sans-serif;
            color: #00ffaa;
            margin-bottom: 2rem;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            background-color: #00ffaa;
            border-radius: 50%;
            box-shadow: 0 0 10px #00ffaa;
            animation: blink 1.5s infinite ease-in-out;
        }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }

        /* System Info */
        .sys-info {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 2rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .info-label {
            font-size: 0.8rem;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 4px;
        }

        .info-value {
            font-size: 1.1rem;
            font-family: 'Orbitron', sans-serif;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="glow"></div>
    <div class="grid"></div>

    <div class="card">
        <div class="status">
            <div class="status-dot"></div>
            SERVEUR EN LIGNE
        </div>
        
        <h1>Bootcamp DevSecOps</h1>
        <h2>Organisé par <span class="highlight">DIKONGUE SAMUEL</span></h2>
        
        <div class="sys-info">
            <div class="info-item">
                <span class="info-label">OS</span>
                <span class="info-value">Debian 12</span>
            </div>
            <div class="info-item">
                <span class="info-label">Serveur Web</span>
                <span class="info-value">Nginx</span>
            </div>
            <div class="info-item">
                <span class="info-label">Adresse IP</span>
                <span class="info-value">192.168.56.10</span>
            </div>
        </div>
    </div>
</body>
</html>
EOF_NGINX

systemctl enable nginx
systemctl restart nginx

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        ✓ Provisioning terminé !          ║"
echo "║                                          ║"
echo "║   vagrant ssh  →  connexion à la VM      ║"
echo "╚══════════════════════════════════════════╝"
echo ""
