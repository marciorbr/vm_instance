data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}
data "vsphere_compute_cluster" "cluster" {
  name = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_datastore" "datastore" {
  name = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  count         = var.vsphere_network != null ? length(var.vsphere_network) : 0
  name          = var.vsphere_network[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name = var.vsphere_virtual_machine
  datacenter_id = data.vsphere_datacenter.dc.id
}
locals {
  interface_count     = length(var.vm_mask)
  template_disk_count = length(data.vsphere_virtual_machine.template.disks)
}

resource "vsphere_virtual_machine" "Linux" {
  count            = var.vm_count
  name             = element(var.vm_name,count.index)
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder
  enable_disk_uuid = var.vm_enable_disk_uuid

  num_cpus = var.vm_cpus
  num_cores_per_socket   = var.vm_cores_per_socket
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  dynamic "network_interface" {
    for_each = var.vsphere_network
    content {
      network_id   = data.vsphere_network.network[network_interface.key].id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }

  // Discos definidos na VM Template
  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template.disks
    iterator = template_disks
    content {
      label            = length(var.disk_label) > 0 ? var.disk_label[template_disks.key] : "disk${template_disks.key}"
      size             = var.disk_size_gb != null ? var.disk_size_gb[template_disks.key] : data.vsphere_virtual_machine.template.disks[template_disks.key].size
      unit_number      = var.scsi_controller != null ? var.scsi_controller * 15 + template_disks.key : template_disks.key
      thin_provisioned = data.vsphere_virtual_machine.template.disks[template_disks.key].thin_provisioned
      eagerly_scrub    = data.vsphere_virtual_machine.template.disks[template_disks.key].eagerly_scrub
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.vm_linked_clone

    customize {
      timeout = "20"

      linux_options {
        host_name = element(var.vm_hostname,count.index)
        domain    = var.vm_domain
        time_zone = var.vm_timezone
      }

      dynamic "network_interface" {
        for_each = var.vsphere_network
        content {
          ipv4_address = var.vm_ipv4[var.vsphere_network[network_interface.key]][count.index]
          ipv4_netmask = "%{if local.interface_count == 1}${var.vm_mask[0]}%{else}${var.vm_mask[network_interface.key]}%{endif}"
        }
      }
      ipv4_gateway    = var.vm_gateway
      dns_suffix_list = var.vm_dns_suffix
      dns_server_list = var.vm_dns_servers
    }
  }
}