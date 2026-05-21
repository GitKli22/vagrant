# 🐧 Serveur DevSecOps — VM Debian 12 (Vagrant)

Machine virtuelle configurée comme une véritable instance Cloud (GCP/AWS) pour le Bootcamp DevSecOps organisé par **DIKONGUE SAMUEL**.

---

## 📋 Prérequis

| Outil | Lien |
|---|---|
| [VirtualBox](https://www.virtualbox.org/wiki/Downloads) | https://virtualbox.org |
| [Vagrant](https://developer.hashicorp.com/vagrant/downloads) | https://vagrantup.com |

---

## ⚡ Démarrage Rapide

Un script a été mis en place pour lancer la machine et s'y connecter automatiquement avec les privilèges `root` :

```bash
chmod +x launch_vps.sh  # Si ce n'est pas déjà fait
./launch_vps.sh
```

*(Si vous préférez utiliser Vagrant directement : `vagrant up` puis `vagrant ssh`, la connexion basculera automatiquement sur l'utilisateur `root`.)*

---

## 🌟 Fonctionnalités DevSecOps

- **Environnement de Production** : Connexion par défaut avec les droits **`root`** pour s'entraîner aux tâches d'administration et de sécurité.
- **Serveur Web Intégré** : **Nginx** est pré-installé avec une page d'accueil personnalisée pour le Bootcamp (disponible sur le port 8080).
- **MOTD Personnalisé** : Message d'accueil "Bootcamp DevSecOps" exclusif à la connexion SSH.
- **Nom d'hôte** : `devsecops-vm`

---

## 🌐 Réseau et Services

| Service / Accès | Adresse / IP |
|---|---|
| **IP Réseau Privé** | `192.168.56.10` |
| **Site Web DevSecOps (Nginx)** | `http://localhost:8080` |
| Port 8000 | `http://localhost:8008` |
| Port 3000 | `http://localhost:3030` |

---

## 🏗️ Ce qui est installé

| Catégorie | Paquets |
|---|---|
| **Serveur Web** | **nginx** |
| Outils de base | curl, wget, git, vim, nano, htop, tree |
| Réseau | net-tools, iputils-ping, dnsutils |
| Développement | build-essential, make, gcc |
| Utilitaires | unzip, zip, bash-completion, man, sudo |

---

## 📁 Structure du Projet

```text
vagrant-debian/
├── Vagrantfile          # Configuration de la VM
├── launch_vps.sh        # Script de démarrage et connexion rapide
├── README.md            # Ce fichier
├── scripts/
│   └── install.sh       # Script de provisioning (installations + MOTD + Nginx)
└── workspace/           # Dossier synchronisé → /root/workspace dans la VM
```

---

## 🔧 Commandes Vagrant Utiles

```bash
vagrant reload --provision  # Appliquer des modifications de install.sh
vagrant halt                # Éteindre la VM
vagrant destroy             # Supprimer la VM
vagrant status              # Vérifier l'état de la VM
```

---

## 📄 Licence

MIT
