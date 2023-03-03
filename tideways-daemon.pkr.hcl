# Set up packer with the AWS plugin
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# This defines the AMI we are creating
source "amazon-ebs" "tideways-daemon" {
  ami_name        = "tideways-daemon"
  ami_description = "Tideways daemon"
  tags = {
    Name = "Tideways daemon"
  }
  # Make the AMI public
  # https://developer.hashicorp.com/packer/plugins/builders/amazon/ebs#ami_groups
  ami_groups = ["all"]
  # Publish the AMI in the following regions
  ami_regions = [
    // US
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
    // Canada
    "ca-central-1",
    // Europe
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    "eu-central-1",
    "eu-north-1",
    // South America
    "sa-east-1",
    // Asia Pacific
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-northeast-3",
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-south-1",
  ]
  # These 2 settings allow overwriting the AMI if it already exists
  # https://developer.hashicorp.com/packer/plugins/builders/amazon/ebs#force_deregister
  force_deregister = true
  force_delete_snapshot = true
  # This is the smallest instance type we can use, eligible to the free tier
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      # Starts from Ubuntu 20.04
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

# This describes what runs in EC2 to create the AMI
build {
  sources = [
    # Points to the base image above
    "source.amazon-ebs.tideways-daemon"
  ]

  provisioner "shell" {
    inline = [
      # Install the daemon
      # See https://support.tideways.com/documentation/setup/installation/debian-ubuntu.html
      "echo 'deb https://packages.tideways.com/apt-packages-main any-version main' | sudo tee /etc/apt/sources.list.d/tideways.list",
      "wget -qO - https://packages.tideways.com/key.gpg | sudo apt-key add -",
      "sudo apt update",
      "sudo apt install -y tideways-daemon",
      "echo 'TIDEWAYS_DAEMON_EXTRA=\"--address=0.0.0.0:9135\"' | sudo tee /etc/default/tideways-daemon",
      "sudo service tideways-daemon restart",
    ]
  }
}
