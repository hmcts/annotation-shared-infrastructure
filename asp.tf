locals {
  ase_name = "core-compute-${var.env}"

  // Tune capacity as needed, should be 1 in non production environments increase further if required
  asp_capacity = "${var.env == "prod" || var.env == "sprod" || var.env == "aat" ? 2 : 1}"

  // I2 in prod like env, I1 everywhere else
  // If you are a new team, try using I1 everywhere, if you have performance problems then use I2
  sku_size = "${var.env == "prod" || var.env == "sprod" || var.env == "aat" ? "I2" : "I1"}"
}

module "appServicePlan" {
  source = "git@github.com:hmcts/cnp-module-app-service-plan?ref=master"
  location = "${var.location}"
  env = "${var.env}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  asp_capacity = "${local.asp_capacity}"
  asp_sku_size = "${local.sku_size}"  // Specifies the plan's instance size (I1 in most cases)
  asp_name = "${var.product}"
  ase_name = "${local.ase_name}"
  tag_list = "${local.tags}"
}