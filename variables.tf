variable "cluster_id" {
  type = string
  description = "Cluster identifier"
}

variable "cluster_dir" {
  type = string
  description = "Directory containing cluster configurations"
}

variable "storage_class" {
  type = string
  description = "Storage class name for the provisioner"
  default = "nfs"
}

variable "pvc_storage_class" {
  type = string
  description = "Storage class name to be used to create backing storage for provisioner"
  default = "thin"
}

variable "pvc_size" {
  type = string
  description = "Size of the volume to create as backing storage for provisioner"
  default = "500G"
}

variable "image" {
  type = string
  description = "Docker image to run the server"
  default = "quay.io/kubernetes_incubator/nfs-provisioner:latest"
}

variable "is_default_class" {
  type = string
  description = "Should created storage class be the default"
  default = "false"
}

