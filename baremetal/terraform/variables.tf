variable "base_url" {
  type    = string
  default = "http://localhost:3000"
}

variable "access_token" {
  description = "OpenCHAMI access token"
  type        = string
  nullable    = false
  default     = "../access_token"
}

variable "bss_initrd" {
  type = string
}

variable "bss_kernel" {
  type = string
}

variable "bss_params" {
  type = string
}

variable "cloud_init" {
  type = string
}

variable "filename_nodes_csv" {
  type    = string
  default = "../data/nodes.csv"
}

variable "filename_cloud_init_group" {
  type    = string
  default = "cloud-init-group-payload.yaml"
}

variable "public_keys" {
  type = list(string)
}
