resource "azurerm_resource_group" "shared_resource_group" {
  name = "${var.product}-${var.env}"
  location = "${var.location}"
  tags {
    "Deployment Environment" = "${var.env}"
    "Team Contact" = "#<em-dev-chat>"
    "Destroy Me" = "${var.destroy_me}"
  }
}

