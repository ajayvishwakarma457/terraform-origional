
resource "aws_lightsail_key_pair" "this" {
  name       = "${var.project_name}-key"
  public_key = file("${path.module}/id_rsa.pub")
}


# ---------------------------------
# AWS Lightsail Instance
# ---------------------------------

resource "aws_lightsail_instance" "this" {
  name              = "${var.project_name}-lightsail"
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  key_pair_name     = aws_lightsail_key_pair.this.name  # ✅ use auto-created key

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-lightsail"
  })
}

# Optional static public IP
resource "aws_lightsail_static_ip" "this" {
  name = "${var.project_name}-lightsail-ip"
}

# Attach IP to instance
resource "aws_lightsail_static_ip_attachment" "attach" {
  instance_name = aws_lightsail_instance.this.name
  static_ip_name = aws_lightsail_static_ip.this.name
}
