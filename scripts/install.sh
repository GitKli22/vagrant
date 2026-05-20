#!/usr/bin/env bash
# =============================================================================
#  install.sh — Provisioning de la VM Debian 12
#  Exécuté automatiquement au premier "vagrant up"
# =============================================================================

set -euo pipefail

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Provisioning VM Debian 12 (Bookworm)   ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── 1. Mise à jour du système ─────────────────────────────────────────────────
echo "▶ [1/5] Mise à jour du système..."
apt-get update -qq
apt-get upgrade -y -qq

# ── 2. Paquets essentiels ─────────────────────────────────────────────────────
echo "▶ [2/5] Installation des paquets essentiels..."
apt-get install -y -qq \
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
  sudo

# ── 3. Configuration du fuseau horaire ───────────────────────────────────────
echo "▶ [3/5] Configuration du fuseau horaire (Europe/Paris)..."
timedatectl set-timezone Europe/Paris 2>/dev/null || \
  ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

# ── 4. Configuration de l'environnement utilisateur vagrant ──────────────────
echo "▶ [4/5] Configuration de l'environnement utilisateur..."

# Alias utiles dans .bashrc
cat >> /home/vagrant/.bashrc << 'EOF'

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

# Prompt coloré avec nom de la VM
export PS1='\[\033[01;32m\]\u@debian-dev\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
EOF

# Dossier workspace propre
mkdir -p /home/vagrant/workspace
chown -R vagrant:vagrant /home/vagrant/workspace

# ── 5. Message de bienvenue ───────────────────────────────────────────────────
echo "▶ [5/5] Configuration du message de bienvenue..."
cat > /etc/motd << 'EOF'

____  ____  ____ ___    _    _   _
 |  _ \| ___|| __ )_ _|  / \  | \ | |
 | | | |___ \|  _ \| |  / _ \ |  \| |
 | |_| |___) | |_) | | / ___ \| |\  |
 |____/|____/|____/___/_/   \_\_| \_|

  ____                              _
 / ___|  __ _  _ __ ___   _   _  _| |
 \___ \ / _` || '_ ` _ \ | | | |/ _ |
  ___) || (_| || | | | | || |_| |  __/
 |____/  \__,_||_| |_| |_| \__,_|\___|

  VM Debian 12 (Bookworm) — Vagrant
  ──────────────────────────────────
  IP privée   : 192.168.56.10
  Workspace   : ~/workspace  (synchronisé avec ./workspace/)
  Projet      : /vagrant     (synchronisé avec le dossier racine)

  Commandes utiles :
    ports      → afficher les ports en écoute
    myip       → afficher les IPs
    ll         → ls amélioré

EOF

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        ✓ Provisioning terminé !          ║"
echo "║                                          ║"
echo "║   vagrant ssh  →  connexion à la VM      ║"
echo "╚══════════════════════════════════════════╝"
echo ""
