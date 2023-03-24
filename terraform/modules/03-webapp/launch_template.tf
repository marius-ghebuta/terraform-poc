
resource "aws_security_group" "sg" {
  name        = "${var.name_prefix}-sg"
  description = "Allow inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

    dynamic "ingress" {
        for_each = var.sg_ingress_rules
        content {
                from_port        = ingress.value.from_port
                to_port          = ingress.value.to_port
                protocol         = ingress.value.protocol
                cidr_blocks      = ingress.value.cidr_blocks
        }
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}


resource "aws_launch_template" "launch_template" {
  name = "${var.name_prefix}-launch-template"
  ebs_optimized = false
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = null
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = filebase64("${path.module}/user-data.sh")

 iam_instance_profile {
    name = aws_iam_instance_profile.test_profile.name
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      LAUNCH_TEMPLATE = "TRUE"
      NAME            = "${var.name_prefix}"
    }
  }
}


