# README

# Clone All Code | [中文README](https://github.com/leihaowen/clone_all_code/blob/main/README_CN.md)

This is a shell script that helps you to clone the code, from gitlab, recursively and maintain the project module structure.

## Let’s get started

1. Install a [🔗jq](https://jqlang.github.io/jq/) which helps parse json. if you are using mac try

```bash
brew install jq
```

2. Prepare some arguments and replace it

```bash
GITLAB_TOKEN="***"
ABSOLUTE_PATH="/Users/mymac/Documents/go/"
PARENT_GROUP_ID="123"
GITLAB_ADDRESS="gitlab.***.com"
```

**GITLAB_TOKEN**: generated from you gitlab UserSettings → AccessTokens. Make sure you select api access.

**ABSOLUTE_PATH**: use your own path

**PARENT_GROUP_ID**: use your project group id that you can find on you gitlab page.

**GITLAB_ADDRESS**: use your own gitlab address.

replace the script setting

3. run script

```bash
./copy_codes.sh
```

Please note that the actual GitLab token, absolute path, parent group ID, and GitLab address should be substituted according to your specific GitLab environment and project details.