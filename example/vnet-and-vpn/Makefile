.PHONY: init
init:
	terraform init

.PHONY: login
login:
	az login

.PHONY: plan
plan:
	terraform plan -out "terraform.plan"

.PHONY: apply
apply:
	terraform apply "terraform.plan"

.PHONY: destroy
destroy:
	terraform destroy
