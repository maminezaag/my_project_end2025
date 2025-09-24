
/*output "k8s_master_ip" {
  value = proxmox_virtual_environment_vm.k8s_master.default_ipv4_address
  }


output "k8s_worker_ips" {
  value = [for w in proxmox_vm_qemu.k8s-worker : w.default_ipv4_address]
}

output "ansible_ip" {
  value = proxmox_vm_qemu.ansible.default_ipv4_address
}

output "terraform_ip" {
  value = proxmox_vm_qemu.terraform.default_ipv4_address
}
*/
