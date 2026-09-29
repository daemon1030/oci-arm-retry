terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.0"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
}

# This workflow deliberately does not persist Terraform state. Treat a
# non-terminated instance with this name as the successful result so a later
# retry cannot create a duplicate while the first launch is pending.
data "oci_core_instances" "existing" {
  compartment_id = var.compartment_id
  display_name   = var.instance_name
}

locals {
  existing_non_terminated_instances = [
    for instance in data.oci_core_instances.existing.instances : instance
    if instance.state != "TERMINATED"
  ]
}

# Platform images belong to the tenancy. OCI's unfiltered platform-image list
# does not reliably include the Minimal ARM variant, so query that variant by
# its exact display name.
data "oci_core_images" "ubuntu" {
  compartment_id = coalesce(var.image_compartment_id, var.tenancy_ocid)
  display_name   = var.image_display_name
}

resource "oci_core_instance" "arm_vm" {

  # A display name is the idempotency key for this retry-only workflow.
  # Do not change it after a successful launch unless a second VM is intended.
  count = length(local.existing_non_terminated_instances) == 0 ? 1 : 0

  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id

  display_name = var.instance_name
  shape        = var.shape

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = var.assign_public_ip
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  freeform_tags = {
    ManagedBy = "github-actions"
    Purpose   = "oci-arm-retry"
  }
}
