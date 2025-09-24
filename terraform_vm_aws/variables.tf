variable "proxmox_host" {
  description = "Adresse IP du serveur Proxmox"
  type        = string
}

variable "proxmox_user" {
  description = "Utilisateur Proxmox"
  type        = string
}

variable "proxmox_password" {
  description = "Mot de passe Proxmox"
  type        = string
  sensitive   = true
}

variable "proxmox_port" {
  description = "port de proxmox"
  type        = string
  sensitive   = true
}


variable "kuberpass" {
  description = "port de proxmox"
  type        = string
  sensitive   = true
}



