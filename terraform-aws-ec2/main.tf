terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}


resource "aws_instance" "mongodb_stg" {
  count = 7 # Here we are creating identical 7 machines.
  ami = var.ami
  instance_type  = var.instance_type
  key_name = "ZZZZZZ"
  subnet_id = "subnet-YYYYYYY"
  vpc_security_group_ids = [ "sg-XXXXXXXXX" ]
  # security_groups = "mongodb-sg"
  root_block_device{
#    device_name = "/dev/sda1"
    delete_on_termination = true
  }
  tags = {
    Name = "mongo-slavescaler-stg-${count.index}"
  }
  # provisioner "local-exec" {
  #   command = "sed -i 's/${self.private_ip}/self.private_ip/g' /home/dungnt/terraform-aws-ec2/joincluster.sh"
  # }
  connection {
  type     = "ssh"
  user     = "ubuntu"
  private_key = file("/home/dungnt/.ssh/ZZZZZZ.pem")
  host     = "${self.private_ip}"
  }
  provisioner "file" {
    source      = "/home/dungnt/terraform-aws-ec2/joincluster.sh"
    destination = "/tmp/joincluster.sh"
  }
  provisioner "file" {
    source      = "/home/dungnt/.ssh/ZZZZZZ.pem"
    destination = "/home/ubuntu/.ssh/ZZZZZZ.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)",
      "chmod +x /tmp/joincluster.sh",
      "bash /tmp/joincluster.sh",
    ]
  }
}


# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "Redis-scaletest" {
#   count = 4 # Here we are creating identical 4 machines.
#   ami = var.ami
#   instance_type  = var.instance_type
#   key_name = "ZZZZZZ"
#   subnet_id = "subnet-YYYYYYY"
#   root_block_device{
# #    device_name = "/dev/sda1"
#     delete_on_termination = true
#   }
#   tags = {
#     Name = "Redis-scaletest-0${count.index}"
#   }
  # for_each  = {                     # for_each iterates over each key and values
  #     key1 = "t2.micro"             # Instance 1 will have key1 with t2.micro instance type
  #     key2 = "t2.medium"            # Instance 2 will have key2 with t2.medium instance type
  #       }
  #       instance_type  = each.value
	#       key_name       = each.key
  #   tags =  {
	#    Name  = each.value
	# }
# }