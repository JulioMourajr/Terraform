variable "cidrvpc" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "iops" {
  description = "IOPS for the RDS"
  type        = number
  default     = 3000

}

variable "allocated_storage" {
  description = "Allocated storage for the RDS"
  type        = number
  default     = 400
}