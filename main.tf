provider "vsphere" {
  user           = "${var.username}"
  password       = "${var.password}"
  vsphere_server = "${var.vcenter}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "iso_datastore" {
  name          = "${var.iso_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  wait_for_guest_net_timeout = "0"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 20
  }

 cdrom {
    datastore_id = "${data.vsphere_datastore.iso_datastore.id}"
    path = "iso/Core-current.iso"
  }
}
