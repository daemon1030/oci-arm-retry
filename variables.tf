variable "tenancy_ocid" {
  type      = string
  sensitive = true
}

variable "user_ocid" {
  type      = string
  sensitive = true
}

variable "fingerprint" {
  type      = string
  sensitive = true
}

variable "private_key" {
  type      = string
  sensitive = true
}

variable "region" {
  type = string
}

variable "compartment_id" {
  type = string
}

variable "availability_domain" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "image_compartment_id" {
  type        = string
  default     = null
  nullable    = true
  description = "Custom image compartment OCID. Leave null to use OCI platform images from the tenancy."
}

variable "image_operating_system" {
  type        = string
  default     = "Canonical Ubuntu"
  description = "OCI operating-system filter for the platform image."
}

variable "image_operating_system_version" {
  type        = string
  default     = "24.04"
  description = "OCI operating-system-version filter for the platform image."
}

variable "instance_name" {
  type    = string
  default = "arm-server"
}

variable "shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "ocpus" {
  type    = number
  default = 1
}

variable "memory_in_gbs" {
  type    = number
  default = 6
}

variable "assign_public_ip" {
  type        = bool
  default     = true
  description = "Whether the primary VNIC receives a public IP address."
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}
