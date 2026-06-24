locals {
  raw_csv_data      = file(var.filename_nodes_csv)
  intermediate_list = csvdecode(local.raw_csv_data)
  nodes = tomap({ for inst in local.intermediate_list : inst.host => {
    rfe = {
      hostname = inst.rfe_ip
      xname    = inst.rfe_xname
      password = inst.rfe_password
    }
    node = {
      xname = inst.node_xname
      ip    = inst.node_ip
      mac   = inst.node_mac
    }
  } })
  list_nodes = [for node in local.nodes : "${node.node.xname}"]
}
