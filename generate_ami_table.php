<?php

$amiRegions = [
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
];

echo <<<MKDN
| Region    | AMI ID                |
|-----------|-----------------------|

MKDN;

foreach ($amiRegions as $amiRegion) {
    $output = shell_exec("aws ec2 describe-images --filters 'Name=name,Values=tideways-daemon' --owners='601180370863' --query='Images[*].[ImageId]' --output=text --region=" . $amiRegion);
    printf("| %s | %s |\n", $amiRegion, trim($output));
}
