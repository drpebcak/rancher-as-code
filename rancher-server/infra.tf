resource "aws_security_group" "rancher_elb" {
  name   = "${local.name}-rancher-elb"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rancher" {
  name   = "${local.name}-rancher-server"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.rancher_elb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "TCP"
    security_groups = [aws_security_group.rancher_elb.id]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
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
resource "aws_instance" "rancher-master" {
  count         = local.master_node_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id
  user_data     = data.template_file.cloud_config.rendered

  vpc_security_group_ids      = [aws_security_group.rancher.id]
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

resource "aws_instance" "rancher-worker" {
  count         = local.worker_node_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id
  user_data     = data.template_file.cloud_config.rendered

  vpc_security_group_ids      = [aws_security_group.rancher.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.available.ids), 0)
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  tags = {
    Name        = "${local.name}-worker-${count.index}"
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
}

resource "aws_elb" "rancher" {
  name            = local.name
  subnets         = data.aws_subnet_ids.available.ids
  security_groups = [aws_security_group.rancher_elb.id]

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "tcp:80"
    interval            = 5
  }

  instances    = aws_instance.rancher-worker.*.id
  idle_timeout = 1800

  tags = {
    Name        = local.name
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
}

resource "aws_route53_record" "rancher" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = "${local.name}.${local.domain}"
  type    = "A"

  alias {
    name                   = aws_elb.rancher.dns_name
    zone_id                = aws_elb.rancher.zone_id
    evaluate_target_health = true
  }
}

########################################
### Wait for docker install on nodes
########################################
resource "null_resource" "wait_for_docker" {
  count = local.master_node_count + local.worker_node_count

  triggers = {
    instance_ids = join(",", concat(aws_instance.rancher-master.*.id, aws_instance.rancher-worker.*.id))
  }

  provisioner "local-exec" {
    command = <<EOF
while [ "$${RET}" -gt 0 ]; do
    ssh -q -o StrictHostKeyChecking=no -i $${KEY} $${USER}@$${IP} 'docker ps 2>&1 >/dev/null'
    RET=$?
    if [ "$${RET}" -gt 0 ]; then
        sleep 10
    fi
done
EOF


    environment = {
      RET  = "1"
      USER = "ubuntu"
      IP   = element(concat(aws_instance.rancher-master.*.public_ip, aws_instance.rancher-worker.*.public_ip), count.index)
      KEY  = "${path.root}/outputs/id_rsa"
    }
  }
}
