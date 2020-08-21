
# use virtualenv to install all python requirements
VENVDIR=venv
virtualenv --python=/usr/bin/python3 $VENVDIR
source $VENVDIR/bin/activate
pip3 install -r kubespray/requirements.txt

# prepare an inventory to test with
export INV=inventory
rm -rf ${INV}.bak &> /dev/null
mv ${INV} ${INV}.bak &> /dev/null
cp -a kube_vars ${INV}

# customize the vagrant environment
mkdir vagrant
cat << EOF > vagrant/config.rb
\$instance_name_prefix = "kub"
\$vm_cpus = 1
\$num_instances = 3
\$subnet = "10.0.20"
\$network_plugin = "calico"
\$inventory = "$INV"
\$playbook = "kubespray/cluster.yml"
EOF


vagrant up

export KUBECONFIG=$INV/artifacts/admin.conf
