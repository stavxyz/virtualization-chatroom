# Cloud Infrastructure for virtualization-chatroom

## Requirements

Terraform >= 0.12 : https://www.terraform.io/

DigitalOcean account: https://www.digitalocean.com/

You will need to generate an API token: https://cloud.digitalocean.com/account/api/tokens

Ensure this value is exported as the environment variable
`DIGITALOCEAN_TOKEN` in your shell's environment.

## Usage 

1. Modify variables as desired. See variables.tf for values and
   https://www.terraform.io/docs/configuration/variables.html for more
   info! Variables can be set in this file, as environment variables, or
   on the command line. You've got options!

2. Initialize your terraform workspace

```
terraform init
```
