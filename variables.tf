# ------------------------
# Configurações do Vcenter
variable "vsphere_datacenter" {
  default = "DC"
  description = " Datacenter em que será feito Deploy da VM "
}
variable "vsphere_compute_cluster" {
  default = "Cluster"
  description = " Cluster em que será feito Deploy da VM "
}
variable "vsphere_datastore" {
  default = "NL_SAS_0"
  description = "Qual datastore será usado pela VM"
}
variable "vsphere_network" {
  type        = list(string)
  description = "Qual rede será utilizado pela VM"
}
variable "vsphere_virtual_machine" {
  description = "Nome do Template que será clonado para criar a VM"
}
variable "vsphere_template_folder" {
  description = "Folder onde está o Template"
}

# -------------------------------
# Recursos e Especificações da VM
variable "vm_count" {
  description = "Numbero de VMs criadas no Cluster"
  default = 1
}
variable "vm_name" {
  type        = list(string)
  default     = []
  description = "Lista de Nomes Utilizado pelas VMs no vCenter"
}
variable "vm_folder" {
  description = "Em qual pasta a VM será armazedada"
}
variable "vm_enable_disk_uuid" {
  description = "Exponha os UUIDs dos discos virtuais conectados à máquina virtual"
  type        = bool
  default     = false
}
variable "disk_size_gb" {
  description = "Lista com tamanhos dos disco para subistituir o tamanho default do template da VM."
  type        = list(any)
  default     = null
}
variable "disk_label" {
  description = "Label dos discos."
  type        = list(any)
  default     = []
}
variable "scsi_controller" {
  description = "scsi_controller numero para os disco."
  type        = number
  default     = 0
}
variable "vm_cpus" {
  default = 2
  description = "Quantidade de CPU utilizada pela VM"
}
variable "vm_cores_per_socket" {
  default = 2
  description = "Quantidade de Cores por socket utilizada pela VM"
}
variable "vm_memory" {
  default = 4096
  description = "Quantidade de Memória da VM"
}
variable "vm_linked_clone" {
  description = "Use linked clone para criar vSphere virtual machine para template (true/false). If you would like to use the linked clone feature, your template need to have one and only one snapshot"
  default = "false"
}
variable "vm_hostname" {
  type        = list(string)
  default     = []
  description = "Lista de Nomes 'hostname' Utilizado pelas VMs"
}
variable "vm_domain" {
  default         = "defaul.local"
  description     = " Domínio utilizado pelas VMs"
}
variable "vm_timezone" {
  default     = "America/Porto_Velho"
  description = " Timezone utilizado pela VM "
}
variable "vm_ipv4" {
  type        = map
  description = "Lista de IPs Utilizado pelas VMs"
}
variable "vm_mask" {
  type        = list
  default     = ["24"]
  description = "Máscara de Rede das VMs"
}
variable "vm_gateway" {
  description = "Gateway das Vms"
}
variable "vm_dns_suffix" {
  type        = list(string)
  default     = ["default.local"]
  description = "DNS Domain Utilizados pelas Vms"
}
variable "vm_dns_servers" {
  type    = list(string)
  default = ["8.8.8.8","8.8.4.4"]
  description = "lista de Endereços DNS"
}

variable "vm_user" {    
  description = "Usuário de acesso"
}
variable "vm_password" {
  description = "Senha do usuário"
}
variable "vm_ssh-pub-key" {
  description = "Chave pública de acesso ssh do usuário"
}