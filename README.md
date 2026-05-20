# 🐧 Vagrant — VM Debian 12 (Bookworm)

Machine virtuelle Debian 12 simple et propre, prête en une commande.

---

## 📋 Prérequis

| Outil | Lien |
|---|---|
| [VirtualBox](https://www.virtualbox.org/wiki/Downloads) | https://virtualbox.org |
| [Vagrant](https://developer.hashicorp.com/vagrant/downloads) | https://vagrantup.com |

---

## ⚡ Démarrage

```bash
git clone https://github.com/<ton-username>/vagrant-debian.git
cd vagrant-debian

vagrant up       # Crée et configure la VM (~3 min)
vagrant ssh      # Connexion SSH
```

---

## 🏗️ Ce qui est installé

| Catégorie | Paquets |
|---|---|
| Outils de base | curl, wget, git, vim, nano, htop, tree |
| Réseau | net-tools, iputils-ping, dnsutils |
| Développement | build-essential, make, gcc |
| Utilitaires | unzip, zip, bash-completion, man |

---

## 🌐 Réseau

| Accès | Adresse |
|---|---|
| IP réseau privé | `192.168.56.10` |
| Port 80 (web) | `http://localhost:8080` |
| Port 8000 | `http://localhost:8000` |
| Port 3000 | `http://localhost:3000` |

---

## 📁 Structure

```
vagrant-debian/
├── Vagrantfile          # Config de la VM
├── .gitignore
├── README.md
├── scripts/
│   └── install.sh       # Script de provisioning
└── workspace/           # Dossier partagé → ~/workspace dans la VM
```

---

## 🔧 Commandes

```bash
vagrant up          # Démarrer la VM
vagrant ssh         # Se connecter
vagrant halt        # Éteindre
vagrant reload      # Redémarrer
vagrant provision   # Relancer le script d'installation
vagrant destroy     # Supprimer la VM
vagrant status      # État de la VM
```

---

## 📄 Licence

MIT
