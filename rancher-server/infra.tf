resource "aws_security_group" "rancher_elb" {
  name   = "${local.name}-rancher-elb"
  vpc_id = local.vpc_id

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
  vpc_id = local.vpc_id

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
resource "aws_launch_template" "rancher_master" {
  count         = local.use_asgs_for_rancher_infra ? 1 : 0
  name_prefix   = "${local.name}-master"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id

  user_data = base64encode(templatefile("${path.module}/files/cloud-config.yaml", { extra_ssh_keys = var.extra_ssh_keys }))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.rancher.id]
  }

  tags = {
    Name        = "${local.name}-master"
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
}

resource "aws_launch_template" "rancher_worker" {
  count         = local.use_asgs_for_rancher_infra ? 1 : 0
  name_prefix   = "${local.name}-worker"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id

  user_data = base64encode(templatefile("${path.module}/files/cloud-config.yaml", { extra_ssh_keys = var.extra_ssh_keys }))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.rancher.id]
  }

  tags = {
    Name        = "${local.name}-master"
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
}

resource "aws_autoscaling_group" "rancher_master" {
  count               = local.use_asgs_for_rancher_infra ? 1 : 0
  name_prefix         = "${local.name}-master"
  desired_capacity    = local.master_node_count
  max_size            = local.master_node_count
  min_size            = local.master_node_count
  vpc_zone_identifier = local.rancher2_master_subnet_ids

  launch_template {
    id      = aws_launch_template.rancher_master.0.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "rancher_worker" {
  count               = local.use_asgs_for_rancher_infra ? 1 : 0
  name_prefix         = "${local.name}-worker"
  desired_capacity    = local.worker_node_count
  max_size            = local.worker_node_count
  min_size            = local.worker_node_count
  vpc_zone_identifier = local.rancher2_worker_subnet_ids

  launch_template {
    id      = aws_launch_template.rancher_worker.0.id
    version = "$Latest"
  }
}

resource "aws_instance" "rancher_master" {
  count         = local.use_asgs_for_rancher_infra ? 0 : local.master_node_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id
  user_data     = templatefile("${path.module}/files/cloud-config.yaml", { extra_ssh_keys = var.extra_ssh_keys })

  vpc_security_group_ids      = [aws_security_group.rancher.id]
  subnet_id                   = element(tolist(local.rancher2_master_subnet_ids), 0)
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

resource "aws_instance" "rancher_worker" {
  count         = local.use_asgs_for_rancher_infra ? 0 : local.worker_node_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = aws_key_pair.ssh.id
  user_data     = templatefile("${path.module}/files/cloud-config.yaml", { extra_ssh_keys = var.extra_ssh_keys })

  vpc_security_group_ids      = [aws_security_group.rancher.id]
  subnet_id                   = element(tolist(local.rancher2_worker_subnet_ids), 0)
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
  subnets         = local.aws_elb_subnet_ids
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

  instances    = aws_instance.rancher_worker.*.id
  idle_timeout = 1800

  tags = {
    Name        = local.name
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
}

resource "aws_route53_record" "rancher" {
  zone_id  = data.aws_route53_zone.dns_zone.zone_id
  name     = "${local.name}.${local.domain}"
  type     = "A"
  provider = aws.r53

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
    instance_ids = local.use_asgs_for_rancher_infra ? join(",", concat(data.aws_instances.rancher_worker.ids, data.aws_instances.rancher_master.ids)) : join(",", concat(aws_instance.rancher_master.*.id, aws_instance.rancher_worker.*.id))
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
      USER = var.instance_ssh_user
      IP   = local.use_asgs_for_rancher_infra ? element(concat(data.aws_instances.rancher_master.public_ips, aws_instance.rancher_worker.*.public_ip), count.index) : element(concat(aws_instance.rancher_master.*.public_ip, aws_instance.rancher_worker.*.public_ip), count.index)
      KEY  = "${var.creds_output_path}/id_rsa"
    }
  }
}

resource "aws_s3_bucket" "etcd_backups" {
  bucket = "${local.name}-rancher-etcd-backup"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_iam_user" "etcd_backup_user" {
  name = "${local.name}-etcd-backup"
}

resource "aws_iam_access_key" "etcd_backup_user" {
  user = aws_iam_user.etcd_backup_user.name
}

resource "aws_iam_user_policy" "etcd_backup_user" {
  name = "${aws_iam_user.etcd_backup_user.name}-policy"
  user = aws_iam_user.etcd_backup_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "etcdBackupBucket",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.etcd_backups.arn}",
                "${aws_s3_bucket.etcd_backups.arn}/*"
            ]
        }
    ]
}
EOF

}
