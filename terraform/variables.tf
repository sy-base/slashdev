variable "deployment_branch" {
    description = "Git deployment branch"
    type        = string
    default     = "master"
}

variable "ec2_image_name" {
    description = "ec2 instance image name (filter)"
    type        = string
    default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}
variable "ec2_image_owner" {
    description = "ec2 instance image owner"
    type        = string
    default     = "099720109477"
}
variable "ec2_instance_type" {
    description = "ec2 instance type"
    type        = string
    default     = "t3a.micro"
}
variable "ec2_instance_sshkey"{
    description = "Pre-defined ec2 instance key"
    type        = string
    default     = "bacon-id_rsa"
}
variable "ec2_instance_securitygroup_ids" {
    description = "Pre-defined ec2 security group ids"
    type        = list(string)
    default     = [ "sg-050c874d", "sg-af64efe7", "sg-2730916e" ]
}
