#!/bin/bash
# ======================================================
# Script pour créer un template Ubuntu Cloud-Init dans Proxmox
# Compatible Proxmox VE 8.3
# ======================================================

# -------------------------------
# 1. Variables de base
# -------------------------------
TEMPLATE_ID=9000                  # ID unique pour la VM template
TEMPLATE_NAME="ubuntu-template"   # Nom du template dans Proxmox
MEMORY=2048                       # RAM allouée au template (en MB)
CORES=2                           # Nombre de vCPU
STORAGE="local-lvm"               # Storage où sera placé le disque (adapter si besoin)
BRIDGE="vmbr0"                    # Bridge réseau par défaut
IMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMG_FILE="/var/lib/vz/template/iso/jammy-server-cloudimg-amd64.img"

# -------------------------------
# 2. Télécharger l’image Ubuntu Cloud
# -------------------------------
echo "==> Téléchargement de l'image Ubuntu Cloud..."
if [ ! -f "$IMG_FILE" ]; then
    wget -O $IMG_FILE $IMG_URL
else
    echo "Image déjà présente, téléchargement ignoré."
fi

# -------------------------------
# 3. Créer la VM "vide"
# -------------------------------
echo "==> Création de la VM $TEMPLATE_ID..."
qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE

# -------------------------------
# 4. Importer le disque cloud-init
# -------------------------------
echo "==> Import du disque dans le storage $STORAGE..."
qm importdisk $TEMPLATE_ID $IMG_FILE $STORAGE

# -------------------------------
# 5. Attacher le disque importé et configurer le boot
# -------------------------------
echo "==> Attachement du disque au contrôleur SCSI..."
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-$TEMPLATE_ID-disk-0

# Définir le disque comme disque de boot
qm set $TEMPLATE_ID --boot c --bootdisk scsi0

# -------------------------------
# 6. Ajouter un périphérique cloud-init
# -------------------------------
echo "==> Ajout du disque Cloud-Init..."
qm set $TEMPLATE_ID --ide2 ${STORAGE}:cloudinit

# -------------------------------
# 7. Activer la console série (facilite debug)
# -------------------------------
qm set $TEMPLATE_ID --serial0 socket --vga serial0

# -------------------------------
# 8. (Optionnel) Définir user/clé SSH par défaut
# NOTE : tu peux commenter si tu préfères gérer ça depuis Terraform
# -------------------------------
# qm set $TEMPLATE_ID --ciuser ubuntu
# qm set $TEMPLATE_ID --sshkey ~/.ssh/id_rsa.pub
# qm set $TEMPLATE_ID --cipassword "ChangeMe!"

# -------------------------------
# 9. Convertir en template
# -------------------------------
echo "==> Conversion de la VM en template..."
qm template $TEMPLATE_ID

echo "==> Template $TEMPLATE_NAME ($TEMPLATE_ID) créé avec succès !"

