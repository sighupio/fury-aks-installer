# AKS Networking example

To execute the example, do the following:

```bash
# Download dependencies
terraform init

# Plan
terraform plan -out "terraform.plan"

# Apply
terraform apply "terraform.plan"

# Generate OpenVPN credentials
furyagent configure openvpn-client --client-name fury-aks-installer --config secrets/furyagent.yml > fury-aks-installer.ovpn

```

To cleanup:

```bash
terraform destroy
```