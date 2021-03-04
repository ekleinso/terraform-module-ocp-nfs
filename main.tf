locals {
  project = "${var.cluster_id}-storage"
}

data "template_file" "k8s_storage_yaml" {
  template = file("${path.module}/templates/nfs.tpl")
  vars = {
    pvc_size = var.pvc_size
    pvc_storage_class = var.pvc_storage_class
    provisioner_image = var.image
    cluster_name = var.cluster_id
    storage_class = var.storage_class
    is_default_class = var.is_default_class
    project = local.project
  }
}

#
resource "local_file" "k8s_storage_yaml" {
    content  = data.template_file.k8s_storage_yaml.rendered
    filename = format("%s/storage/k8s_nfs.yaml", var.cluster_dir)
    file_permission = 644
}

resource "null_resource" "ocp_nfs" {
  provisioner "local-exec" {
    command = <<EOF
set -ex

CURRENT_DEFAULT=`binaries/oc get sc | grep default | awk '{print $1}'`
if [[ "${var.is_default_class}" == "true" && -n "$CURRENT_DEFAULT" ]]; then
  binaries/oc annotate sc/$CURRENT_DEFAULT storageclass.kubernetes.io/is-default-class-
fi

binaries/oc apply -f ${local_file.k8s_storage_yaml.filename}
binaries/oc project ${local.project}
binaries/oc adm policy add-scc-to-user ${var.cluster_id}-nfs-provisioner -z nfs-provisioner

EOF

    environment = {
      KUBECONFIG  = format("%s/auth/kubeconfig", var.cluster_dir)
    }

    working_dir = var.cluster_dir
  }

  depends_on = [
    local_file.k8s_storage_yaml
  ]
}

