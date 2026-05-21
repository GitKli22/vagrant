# -*- mode: ruby -*-
# vi: set ft=ruby :

# ─────────────────────────────────────────────────────────────────────────────
#  Vagrant — VM Debian 12 (Bookworm)
#  Une seule VM propre, prête à l'emploi
#
#  Accès :
#    vagrant ssh          → connexion SSH
#    http://localhost:8080 → si tu actives un serveur web
#    192.168.56.10        → IP réseau privé
# ─────────────────────────────────────────────────────────────────────────────

Vagrant.configure("2") do |config|

  # ── Box Debian 12 officielle ─────────────────────────────────────────────
  config.vm.box = "generic/debian12"

  # ── Hostname ─────────────────────────────────────────────────────────────
  config.vm.hostname = "devsecops-vm"

  # ── Réseau ───────────────────────────────────────────────────────────────
  config.vm.network "private_network", ip: "192.168.56.10"
  # Après
  config.vm.network "forwarded_port", guest: 80,   host: 8080, host_ip: "127.0.0.1", auto_correct: true
  config.vm.network "forwarded_port", guest: 8000, host: 8008, host_ip: "127.0.0.1", auto_correct: true
  config.vm.network "forwarded_port", guest: 3000, host: 3030, host_ip: "127.0.0.1", auto_correct: true

  # ── Dossier partagé ──────────────────────────────────────────────────────
  # Le dossier courant est monté dans /vagrant automatiquement
  # Dossier de travail supplémentaire :
  config.vm.synced_folder "./workspace", "/root/workspace",
    create: true, owner: "root", group: "root"

  # ── Ressources VirtualBox ────────────────────────────────────────────────
  config.vm.provider "virtualbox" do |vb|
    vb.name   = "vagrant-debian"
    vb.memory = "1024"
    vb.cpus   = 1
    vb.gui    = false
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1",        "on"]
  end

  # ── Provisioning Shell ───────────────────────────────────────────────────
  config.vm.provision "shell", path: "scripts/install.sh"

end
