resource "manta_rfe" "rfe" {
  for_each = local.nodes

  id                 = each.value.rfe.xname
  user               = "root"
  hostname           = each.value.rfe.hostname
  rediscoveronupdate = true
  enabled            = true
  password_wo        = each.value.rfe.password
}

resource "manta_bss_boot_parameters" "default" {
  for_each = local.nodes

  macs   = [each.value.node.mac]
  kernel = var.bss_kernel
  initrd = var.bss_initrd
  params = var.bss_params
}

resource "manta_smd_interface" "eth" {
  for_each = local.nodes

  component_id = each.value.node.xname
  mac_address  = each.value.node.mac
  ip_addresses = [each.value.node.ip]

  depends_on = [manta_rfe.rfe]
}

resource "manta_cloudinit_defaults" "defaults" {
  base_url    = var.cloud_init
  public_keys = var.public_keys
}

resource "manta_cloudinit_group" "compute" {
  name        = "compute"
  description = "The compute group"
  file = {
    content  = file(var.filename_cloud_init_group)
    encoding = "base64"
  }
}

resource "manta_group" "compute" {
  label   = "compute"
  members = local.list_nodes

  depends_on = [manta_rfe.rfe]
}

resource "manta_node" "node" {
  for_each = local.nodes

  id    = each.value.node.xname
  state = "On"

  depends_on = [
    manta_group.compute,
    manta_smd_interface.eth,
    manta_bss_boot_parameters.default
  ]
}
