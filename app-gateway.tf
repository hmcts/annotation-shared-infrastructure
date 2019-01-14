data "azurerm_key_vault_secret" "cert" {
  name      = "${var.certificate_name}"
  vault_uri = "https://infra-vault-${var.subscription}.vault.azure.net/"
}

module "appGw" {
  source            = "git@github.com:hmcts/cnp-module-waf?ref=stripDownWf"
  env               = "${var.env}"
  subscription      = "${var.subscription}"
  location          = "${var.location}"
  wafName           = "${var.product}-shared-waf"
  resourcegroupname = "${azurerm_resource_group.rg.name}"

  # vNet connections
  gatewayIpConfigurations = [
    {
      name     = "internalNetwork"
      subnetId = "${data.azurerm_subnet.subnet_a.id}"
    },
  ]

  sslCertificates = [
    {
      name     = "${var.certificate_name}"
      data     = "${data.azurerm_key_vault_secret.cert.value}"
      password = ""
    },
  ]

  # Http Listeners
  httpListeners = [
    {
      name                    = "${var.product}-http-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort80"
      Protocol                = "Http"
      SslCertificate          = "${var.external_cert_name}" // WAF has ""
      hostName                = "${var.product}-${var.env}.service.core-compute-${var.env}.internal"
    },
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${var.product}-frontend-${var.env}"

      backendAddresses = [
        {
          ipAddress = "${var.ilbIp}"
        },
      ]
    },
  ]

  backendHttpSettingsCollection = [
    // Can have multiple backends, see cnp-module-waf repository
    {
      name                           = "backend-80-nocookies"
      port                           = 80
      Protocol                       = "Http"
      CookieBasedAffinity            = "Disabled"
      AuthenticationCertificates     = ""
      probeEnabled                   = "True"
      probe                          = "http-probe"
      PickHostNameFromBackendAddress = "False"
      HostName                       = "${var.product}-${var.env}.service.core-compute-${var.env}.internal"
    },
 ]

  # Request routing rules
  requestRoutingRules = [
    {
      name                = "${var.product}-http"
      RuleType            = "Basic"
      httpListener        = "${var.product}-http-listener"
      backendAddressPool  = "${var.product}-frontend-${var.env}"
      backendHttpSettings = "backend-80-nocookies"
    },
  ]

  probes = [
    {
      name                                = "http-probe"
      protocol                            = "Http"
      path                                = "/health"
      interval                            = 30
      timeout                             = 30
      unhealthyThreshold                  = 5
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-80-nocookies"
      host                                = "${var.product}-${var.env}.service.core-compute-${var.env}.internal"
      healthyStatusCodes                  = "200-404"                  // MS returns 400 on /, allowing more codes in case they change it
    },
  ]
}
