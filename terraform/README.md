# USE terraform

First init terraform

```
terraform init
```

Export the Apikey of your arvan provider

```
export TF_VAR_arvan_apikey="apikey yourkey"
```

Then test the plan:

```
terraform plan -var-file="variables.tfvars" -out=tfplan
```

Then apply the plan:

```
terraform apply tfplan
```

For destroy:

```
terraform plan -var-file="variables.tfvars" -out=tfplan -destroy
```
