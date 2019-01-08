provider "azurerm" {
  version = "1.19.0"
}

locals {
  new_env = "${var.env}-v2"
  ase_name_legacy = "core-compute-${var.env}"
  ase_name_new = "core-compute-${local.new_env}"

  rg_name = "${var.product}-shared-infrastructure-${var.env}"
  additional_host_name = "${var.product}.platform.hmcts.net"
  vault_name = "${var.product}si-${var.env}"

  tags = "${merge(
    var.common_tags,
    map("Team Contact", var.team_contact)
  )}"
}

resource "azurerm_resource_group" "shared_resource_group" {
  name = "${local.rg_name}"
  location = "${var.location}"
  tags {
    "Deployment Environment" = "${var.env}"
    "Team Contact" = "#<em-dev-chat>"
    "Destroy Me" = "${var.destroy_me}"
  }
}

