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

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
  default     = "10.0.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  default     = "10.0.20.0/24"
}

## Azure Variables