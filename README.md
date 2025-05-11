# Terraform Dynamic Block Configuration for Ingress Rules

This Terraform script defines dynamic ingress rules for managing network access to specific ports on your infrastructure.

## Usage

### Variables

In this script, you can adjust the `web_ingress` variable to define ingress rules for different ports and protocols.
```hcl
variable "web_ingress" {
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr_block  = list(string)
  }))
  default = {
    "80" = {
      description = "Port 80"
      port        = 80
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    }
    "443" = {
      description = "Port 443"
      port        = 443
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    }
  }
}
```

### Dynamic Ingress Rules
The dynamic block `ingress` generates ingress rules based on the `web_ingress` configuration.

```hcl
dynamic "ingress" {
  for_each = local.ingress_rules
  content {
    description = ingress.value.description
    from_port   = ingress.value.port
    to_port     = ingress.value.port
    protocol    = ingress.value.protocol
    cidr_block  = ingress.value.cidr_block
  }
}
```

## Customization
Modify the `web_ingress` variable in `variables.tf` to add or adjust ingress rules for different ports and protocols as needed.

# An Example without Dynamic Block:

# aws_security_group.main:
```
resource "aws_security_group" "main" {
    arn                    = "arn:aws:ec2:us-east-1:508140242758:security-group/sg-00157499a6de61832"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-00157499a6de61832"
    ingress                = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Port 443"
            from_port        = 443
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 443
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Port 80"
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
    ]
    name                   = "core-sg"
    owner_id               = "508140242758"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-0e3a3d76e5feb63c9"
}
```
# Convert Security Group to use dynamic block
```
locals {
  ingress_rules = [{
      port        = 443
      description = "Port 443"
    },
    {
      port        = 80
      description = "Port 80"
    }
  ]
}

resource "aws_security_group" "main" {
  name   = "core-sg"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

### Summary
In this README, we've covered how to configure Terraform for managing dynamic ingress rules and highlighted key backend configurations for state management.

#### Backend Configurations:
- **AWS S3 Backend**: Recommended for storing Terraform state files, supporting features like versioning, encryption, and state locking via DynamoDB.
- **Google Cloud Storage Backend** and **Azure Storage Backend**: Alternative cloud provider options for Terraform state management, offering similar collaboration features.

#### Dynamic Ingress Rules:
- Defined using a Terraform script with a dynamic block, allowing flexible management of network access to specific ports (`web_ingress` variable).

#### Next Steps:
- Customize `web_ingress` in `variables.tf` to add or modify ingress rules according to your infrastructure requirements.
- Consider implementing backend configurations like encryption and state locking for enhanced security and consistency in managing Terraform state.

This README provides a foundational understanding and setup guide for efficiently managing infrastructure configurations with Terraform while leveraging dynamic capabilities for ingress rule management. 
