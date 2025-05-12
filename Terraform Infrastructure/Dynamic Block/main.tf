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
