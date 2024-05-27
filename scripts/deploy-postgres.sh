#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")
echo $PARENT_DIR
WORK_DIR=$PARENT_DIR/postgres

NAMESPACE="postgres-operator"

check_namespace() {
    kubectl get namespace $NAMESPACE >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Namespace '$NAMESPACE' already exists."
        return 0
    else
        echo "Namespace '$NAMESPACE' does not exist."
        return 1
    fi
}

create_namespace() {
    echo "Creating namespace '$NAMESPACE'..."
    kubectl create namespace $NAMESPACE
    if [ $? -ne 0 ]; then
        echo "Failed to create namespace '$NAMESPACE'."
        exit 1
    fi
    echo "Namespace '$NAMESPACE' created successfully."
}

main() {
  check_namespace
  if [ $? -ne 0 ]; then
      create_namespace
  fi

  echo "Installing Helm charts..."
  cd $WORK_DIR
  CHART_DIRS=$(find . -mindepth 1 -maxdepth 1 -type d)
  for chart in $CHART_DIRS; do
    helm install -n $NAMESPACE $(basename $chart) $chart
    if [ $? -ne 0 ]; then
      echo "Failed to install Helm chart"
      exit 1
    fi
    echo "Helm chart installed successfully"
  done 
}

main

echo "Script completed successfully"

