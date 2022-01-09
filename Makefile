# ENV Settings
# export KUBECONFIG=$PWD/kubeconfig.k3d.yaml


.PHONY: cluster_create_local cluster_delete_local

all: 
	@echo '************  Environment ************'
	@echo "* KUBECONFIG: ${KUBECONFIG}"
	@echo '**************************************'


cluster_create_local:
	k3d cluster create --config local/k8-gitops-cluster.k3d.yaml

cluster_delete_local:
	k3d cluster delete --config local/k8-gitops-cluster.k3d.yaml

