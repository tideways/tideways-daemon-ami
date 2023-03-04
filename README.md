# Tideways daemon AMI

To use the AMI, either:

- search for "tideways" in [the AWS AMI catalog](https://console.aws.amazon.com/ec2/v2/home?#AMICatalog)

![](./img/ami-catalog.png)

- or use directly the AMI ID that matches your region (e.g. in `serverless.yml` or a CloudFormation template):

| Region    | AMI ID                |
|-----------|-----------------------|
| us-east-1 | ami-07f65b3cf1dbe83e0 |
| us-east-2 | ami-0682cf12179b408cf |
| us-west-1 | ami-0820fc5dc564c0e59 |
| us-west-2 | ami-0164dde09d9c8ee39 |
| ca-central-1 | ami-0edd27efbce1ccba3 |
| eu-west-1 | ami-0de7fc73978c4a64e |
| eu-west-2 | ami-02606eb4fdcfad3a3 |
| eu-west-3 | ami-05903fecc3810610a |
| eu-central-1 | ami-0f1d41377c06ee5e8 |
| eu-north-1 | ami-0436f9823f2a9b5bf |
| sa-east-1 | ami-096ea12b148055a94 |
| ap-northeast-1 | ami-0b11f0a0b285abd58 |
| ap-northeast-2 | ami-0ffa23a9865810666 |
| ap-northeast-3 | ami-01734b9e496f2c0e0 |
| ap-southeast-1 | ami-0cafbf066a364e8e0 |
| ap-southeast-2 | ami-0e6dea52928ac4850 |
| ap-south-1 | ami-082d2f6ae700b0b1d |

Refresh the list above by running:

```
aws ec2 describe-images --filters 'Name=name,Values=tideways-daemon' --owners='601180370863' --query='Images[*].[ImageId]' --output=text --region=xxx
```

## How it works

The Tideways daemon AMI starts from the base Ubuntu Server 22.04, x86 so that it can run on t2.micro (free tier).

We can create an AMI whose filesystem is either:

- EBS storage (mounted filesystem)
- Instance-store storage

We will use the first option. While it sounds extra steps for un-necessary storage, EBS AMIs are more standard, easier and faster to create, boot faster, can be paused, etc. It also allows to use much slower EC2 instance types, like `t2.micro` which is eligible for the free tier.

### Setup

First, install [the `packer` CLI](https://developer.hashicorp.com/packer/tutorials/aws-get-started/get-started-install-cli).

Then, run `packer init` to install dependencies:

```bash
packer init .
```

Check the configuration is valid:

```bash
packer validate .
```

### Building the AMI

Build the AMI image by running:

```bash
packer build .
```

An EC2 instance will be booted (from the base Ubuntu AMI), and the provisionning scripts will run in that instance. An AMI will be created from that instance. The instance will then be terminated.

The created AMI will be marked as "public".

Full docs: https://developer.hashicorp.com/packer/tutorials/aws-get-started/aws-get-started-build-image
