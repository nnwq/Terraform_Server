# build webserver with a bootstrap
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0ebf6c9a3074a239f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = <<EOF
#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip='curl http://164.254.164.254/latest/meta-data/local-ipv4'
sudo echo "<h2>Webserver with IP: $myip</h2><br>Built with Terraform!"  >  /var/www/html/index.html
sudo service httpd start
chconfig httpd on
  EOF
}

resource "aws_security_group" "my_webserver" {
  name        = "TerraformWebServerSG"
  description = "SmallTerraformWebServer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
