terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

  }
  backend "http" {
  }
}

# Configure the AWS Provider
provider "aws" {}

# Create Lightsail instance, install/configure Cloud C2 
resource "aws_lightsail_instance" "cc2" {
  name              = "cc2"
  availability_zone = "us-east-2a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
  key_pair_name     = "LightsailDefaultKeyPair"
  user_data         = <<EOF
#!/bin/bash
# Install Cloud C2
wget https://c2.hak5.org/dl -q -O c2.zip && unzip -qq c2.zip && \
./c2-*_amd64_linux -hostname cc2.kennethcarnes.com

# Run Cloud C2 as a service
# Move Cloud C2 binary.
sudo mv c2-3.1.2_amd64_linux /usr/local/bin

# Create directory for database file
sudo mkdir /var/cloudc2

# Move database file
sudo mv c2.db /var/cloudc2/

# Create systemd service file. 
sudo vi /etc/systemd/system/cloudc2.service

# Replace parameters as necessary for your instance
[Unit]
Description=Hak5 Cloud C2
After=cloudc2.service
[Service]
Type=idle
ExecStart=/usr/local/bin/c2-3.1.2_amd64_linux -hostname cc2.kennethcarnes.com -db /var/cloudc2/c2.db
[Install]
WantedBy=multi-user.target

# Reload, enable on boot, start and inspect the newly created Cloud C2 service
sudo systemctl daemon-reload
sudo systemctl enable cloudc2.service
sudo systemctl start cloudc2.service
sudo systemctl status cloudc2.service
EOF
}

# Provide static IP attachment
resource "aws_lightsail_static_ip_attachment" "cc2" {
  static_ip_name = aws_lightsail_static_ip.cc2.id
  instance_name  = aws_lightsail_instance.cc2.id
}

resource "aws_lightsail_static_ip" "cc2" {
  name = "cc2_static_ip"
}

# Configure firewall
resource "aws_lightsail_instance_public_ports" "cc2" {
  instance_name = "cc2"

  port_info {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
  }

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 2022
    to_port   = 2022
  }
}