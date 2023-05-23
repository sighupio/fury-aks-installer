# AKS Cluster example

To execute the example, do the following:

```bash
# Download dependencies
terraform init
# Plan
terraform plan -out "terraform.plan"
# Apply
terraform apply "terraform.plan"
# Get admin kubeconfig
terraform output -raw kubeconfig > kubeconfig
# Export kubeconfig
export KUBECONFIG=$PWD/kubeconfig

```

To cleanup:

```bash
terraform destroy
```
