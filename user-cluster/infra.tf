resource "aws_security_group" "user-cluster" {
  name   = "${local.name}-user-cluster"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################
### Create Nodes
#############################
resource "aws_instance" "cluster-master" {
  count         = local.master_node_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id
  user_data     = data.template_file.master-user_data.rendered

  vpc_security_group_ids      = [aws_security_group.user-cluster.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.available.ids), 0)
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  tags = {
    Name        = "${local.name}-master-${count.index}"
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
}

resource "aws_instance" "cluster-worker" {
  count         = local.worker_node_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id
  user_data     = data.template_file.worker-user_data.rendered

  vpc_security_group_ids      = [aws_security_group.user-cluster.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.available.ids), 0)
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  tags = {
    Name        = "${local.name}-user-cluster-${count.index}"
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
}
