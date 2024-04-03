## AWS Variables
variable "aws_public_subnet_cidr_1" {
  type        = string
  description = "CIDR block for the first public subnet"
  default     = "10.0.10.0/24"
}

variable "aws_public_subnet_cidr_2" {
  type        = string
  description = "CIDR block for the second public subnet"
  default     = "10.0.11.0/24"
}

variable "aws_private_subnet_cidr_1" {
  type        = string
  description = "CIDR block for the first private subnet"
  default     = "10.0.20.0/24"
}

variable "aws_private_subnet_cidr_2" {
  type        = string
  description = "CIDR block for the second private subnet"
  default     = "10.0.21.0/24"
}

variable "aws_az_1" {
  type        = string
  description = "Availability zone for the first subnet"
  default     = "us-east-1a"
}

variable "aws_az_2" {
  type        = string
  description = "Availability zone for the second subnet"
  default     = "us-east-1b"
}

## GCP Variables

variable "gcp_public_subnet_cidr" {
  type        = string
  description = "CIDR range for the public subnet"
  default     = "10.0.10.0/24"
}

variable "gcp_private_subnet_cidr" {
  type        = string
  description = "CIDR range for the private subnet"
  default     = "10.0.20.0/24"
}

## Azure Variables

variable "azure_client_id" {
  description = "The Client ID of the Azure Active Directory application."
  type        = string
  default     = "your_default_client_id"
}

variable "azure_client_secret" {
  description = "The Client Secret (password) of the Azure Active Directory appl     ication."
  type        = string
  default     = "your_default_client_secret"
}

variable "azure_subscription_id" {
  description = "The Subscription ID of your Azure account."
  type        = string
  default     = "your_default_subscription_id"
}

variable "azure_tenant_id" {
  description = "The Tenant ID of your Azure Active Directory."
  type        = string
  default     = "your_default_tenant_id"
}