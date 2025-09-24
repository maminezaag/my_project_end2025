  # providers.tf (ou dans main.tf)

  terraform {
    required_providers {
      proxmox = {
        source  = "bpg/proxmox"
        version = ">=0.56.0"  # ou la dernière version stable
      }
    }
  }




  provider "proxmox" {
    endpoint       = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"
    username         = var.proxmox_user
    password     = var.proxmox_password
    insecure = true
  }

  # Master node
  resource "proxmox_virtual_environment_vm" "k8s_master" {
    name        = "k8s-master"
    node_name = "proxiena"
    clone {
    vm_id = 9000    
     }
    # ⭐⭐ INITIALIZATION BIEN PLACÉ ⭐⭐
  initialization {
    type = "nocloud"

    user_account {
      username = "kuber"
      password = var.kuberpass  # ✅ Référence correcte
    }
    # Network Configuration (Static IP)
    ip_config {
      ipv4 {
address = "192.168.100.220/24"
gateway = "192.168.100.1"
}
    
  }
    }
   
      cpu {
    cores = 2
  }
 memory {
    dedicated = 4096
  }    
  
  disk {
    #datastore_id = "local-lvm"   # à adapter
    size         = 30
    interface = "scsi0"      # <--- requis par bpg/proxmox
    
  }
    
    # Réseau — obligatoire : model

    network_device {
    bridge = "vmbr0"
  }


  }

  /*
  # Worker nodes
  resource "proxmox_vm_qemu" "k8s-worker" {
    count       = 2
    name        = "k8s-worker-${count.index + 1}"
    target_node = "proxmox-node1"
    clone       = "ubuntu-template"
    cores       = 2
    memory      = 2048
    disk {
      size = "20G"
    }
    network {
      bridge = "vmbr0"
    }
  }

  # VM pour Ansible
  resource "proxmox_vm_qemu" "ansible" {
    name        = "ansible"
    target_node = "proxmox-node1"
    clone       = "ubuntu-template"
    cores       = 2
    memory      = 2048
    disk {
      size = "15G"
    }
    network {
      bridge = "vmbr0"
    }
  }

  # VM pour Terraform
  resource "proxmox_vm_qemu" "terraform" {
    name        = "terraform"
    target_node = "proxmox-node1"
    clone       = "ubuntu-template"
    cores       = 2
    memory      = 2048
    disk {
      size = "15G"
    }
    network {
      bridge = "vmbr0"
    }
  }
  */