
//SHARED VARIABLES
variable "subscription" {}

variable "product" {
  type        = "string"
  description = "The name of your application"
  default     = "rhubarb"
}

variable "env" {
  type        = "string"
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "location" {
  type        = "string"
  description = "The location where you would like to deploy your infrastructure"
  default     = "UK South"
}

//APP INSIGHTS SPECIFIC VARIABLES
variable "appinsights_location" {
  type        = "string"
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "UK South"
}

variable "application_type" {
  type        = "string"
  description = "This is the type of application you are creating app insights. Valid values are Web and Other"
  default     = "Web"
}

//KEY VAULT SPECIFIC VARIABLES
variable "tenant_id" {
  type        = "string"
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  type        = "string"
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}

variable "product_group_object_id" {
  type        = "string"
  description = ""
  default     = "300e771f-856c-45cc-b899-40d78281e9c1"
}


variable "team_contact" {
  type        = "string"
  description = "The name of your Slack channel people can use to contact your team about your infrastructure"
  default     = "#Cloud-Native"
}

variable "destroy_me" {
  type        = "string"
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}

// ASP SPECIFIC VARIABLES
variable "asp_capacity" {
  type    = "string"
  default = "2"
}


variable "is_frontend" {
  default = true
}


variable "certificate_name" {
  type = "string"
  default = "STAR-platform-hmcts-net"
  description = "The certificate name to use in public listeners. Should support the public hostname."
}

variable "public_hostname" {
  type = "string"
  default = "rhubarb.platform.hmcts.net"
  description = "The public hostanme to use when accessing rhubarb's frontend"
}

variable "health_check_interval" {
  default     = "60"
  description = "interval between healthchecks in seconds"
}

variable "unhealthy_threshold" {
  default     = "3"
  description = "unhealthy threshold applied to healthprobe"
}

variable "health_check" {
  default     = "/health"
  description = "endpoint for healthcheck"
}


variable "infra_location" {
  type    = "string"
  default = "core-infra"
}


variable "wafSubnetName" {
  # define a <environment>.tfvars file to specify the correct value of this variable
  # for legacy environment use --> "0"
  # for V2 environment user --> "appGw"
  type    = "string"
  default = "0"
}

variable "common_tags" {
  type = "map"
}

variable "nr_of_tm_endpoints" {
  default     = "3"
  description = "Number of endpoints that TM will be pointing to this must be provided upfront and also depends on how many times we call was module"
}
