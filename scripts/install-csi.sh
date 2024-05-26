#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")
echo $PARENT_DIR
WORK_DIR=$PARENT_DIR/rawfile-localpv

# Variables
NAMESPACE="kube-system"  # Change this if you want to install in a different namespace
HELM_RELEASE_NAME="rawfile-csi"
HELM_CHART_PATH="$WORK_DIR/deploy/charts/rawfile-csi/"

STORAGE_CLASS_NAME="rawfile-csi"
CSI_DRIVER_NAME="rawfile.csi.openebs.io"  # Replace with your CSI driver's provisioner name

# Define StorageClass YAML
STORAGE_CLASS_YAML=$(cat <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: $STORAGE_CLASS_NAME
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: $CSI_DRIVER_NAME
parameters:
  parameter1: value1  # Replace with your CSI driver's parameters
  parameter2: value2
reclaimPolicy: Retain
volumeBindingMode: Immediate
EOF
)

# Function to apply StorageClass
apply_storage_class() {
  echo "Applying StorageClass..."
  echo "$STORAGE_CLASS_YAML" | kubectl apply -f -
  if [ $? -ne 0 ]; then
    echo "Failed to apply StorageClass"
    exit 1
  fi
  echo "StorageClass applied successfully"
}

# Function to install Helm chart
install_helm_chart() {
  echo "Installing Helm chart..."
  helm install -n $NAMESPACE $HELM_RELEASE_NAME $HELM_CHART_PATH
  if [ $? -ne 0 ]; then
    echo "Failed to install Helm chart"
    exit 1
  fi
  echo "Helm chart installed successfully"
}

# Main execution
apply_storage_class
install_helm_chart

echo "Script completed successfully"

