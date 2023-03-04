## Setup

### Authorize GitHub Actions to deploy to AWS

In order to let GitHub Actions upload AMIs to AWS, we authorize GitHub via [OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) instead of hardcoded AWS access keys.

This needs to be done once in the AWS console (because no access keys have permissions to deploy via CloudFormation).

- [create stack](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create)
- file: `github-role.yml`
- stack name: github-oidc-provider
- `FullRepoName` parameter: `tideways/tideways-daemon-ami`
