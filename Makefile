# ENV Settings
# export KUBECONFIG=$PWD/kubeconfig.k3d.yaml


.PHONY: cluster_create_local cluster_delete_local argocd_install argocd_check-ready argocd_proxy-ui argocd_get-password 

all: 
	@echo '************  Environment ************'
	@echo "* KUBECONFIG: ${KUBECONFIG}"
	@echo '**************************************'


cluster_create_local:
	k3d cluster create --config local/k8-gitops-cluster.k3d.yaml
	
cluster_delete_local:
	k3d cluster delete --config local/k8-gitops-cluster.k3d.yaml

argocd_install:
	kubectl create ns argocd || true
#	helm install argocd charts-root-charts/ -n argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	helm template cluster-root-charts | kubectl apply -n argocd -f -

argocd_check-ready:
	kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s

argocd_get-password:
	# Regular Password
	# kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
	# Initial Password
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

argocd_proxy-ui:
	kubectl port-forward svc/argocd-server -n argocd 9091:80	