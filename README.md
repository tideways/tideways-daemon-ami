# Tideways daemon AMI

The Tideways daemon AMI starts from the base Ubuntu Server 22.04, x86 so that it can run on t2.micro (free tier).

We can create an AMI whose filesystem is either:

- EBS storage (mounted filesystem)
- Instance-store storage

We will use the first option. While it sounds extra steps for un-necessary storage, EBS AMIs are more standard, easier and faster to create, boot faster, can be paused, etc. It also allows to use much slower EC2 instance types, like `t2.micro` which is eligible for the free tier.

## Setup

First, install [the `packer` CLI](https://developer.hashicorp.com/packer/tutorials/aws-get-started/get-started-install-cli).

Then, run `packer init` to install dependencies:

```bash
packer init .
```

Check the configuration is valid:

```bash
packer validate .
```

## Building the AMI

Build the AMI image by running:

```bash
packer build .
```

An EC2 instance will be booted (from the base Ubuntu AMI), and the provisionning scripts will run in that instance. An AMI will be created from that instance. The instance will then be terminated.

The created AMI will be marked as "public".

Full docs: https://developer.hashicorp.com/packer/tutorials/aws-get-started/aws-get-started-build-image
