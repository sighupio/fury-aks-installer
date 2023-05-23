# Fury AKS Installer Example

This folder contains working examples of the terraform modules provided by this Fury Installer.

In order to test them, you follow the instructions below.
Note all comments starting with `TASK: ` require you to run some manual action on your computer
that cannot be automated with the following script.

```bash
# First of all, export the needed env vars for the aks provider to work
# See: https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"

# Or you can login using Azure CLI and (in case) switch to your target subscription
az login
az account set -s "<azure_subscription_id>"

# Bring up the network and bastion
cd examples/networking
cp main.auto.tfvars.dist main.auto.tfvars
# TASK: fill in main.auto.tfvars with your data
terraform init
terraform apply

# Create a OpenVPN client certificate using furyagent
furyagent configure openvpn-client --config=./secrets/furyagent.yml --client-name test > /tmp/fury-example-test.ovpn
# TASK: import the generated /tmp/fury-example-test.ovpn in the openvpn client of your choice and turn it on.

# Bring up the kubernetes cluster
cd ../aks
terraform init
terraform apply

# Once all the above is done you can dump the kube config to a file of your choice
terraform output -raw kubeconfig > /var/tmp/.kubeconfig

# Last but not least, you can verify your cluster is up and running
KUBECONFIG=/var/tmp/.kubeconfig kubectl get nodes
```
