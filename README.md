## Requirements
- virtualbox or libvirt
- python virtualenv
- vagrant

## Installation
Initialize submodules
```
git submodule init && git submodule update
```
Run the install script
```
sh vagrant.sh
```
When this script finishes, the kubernetes cluster should be up and running and accessible with the kube config in artifact directory

# Storage


## Install local path provisioner

```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

Set default storage class

```
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## Github token authentication

```
kubectl apply -f config/github-authn.yaml
```

```
githubUsername=<githubUserID>
```

```
cat << EOF > rbac-cluster-admin.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: $githubUsername
EOF

kubectl apply -f rbac-cluster-admin.yml
```

