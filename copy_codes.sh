#!/bin/bash

# Replace 'GITLAB_TOKEN' with your GitLab personal access token
# Replace 'ABSOULTE_PATH' with your local absoulte path
# Replace 'PARENT_GROUP_ID' with your GitLab group id
# Replace 'GITLAB_ADDRESS' with your GitLab address
GITLAB_TOKEN="***"
ABSOULTE_PATH="/Users/mymac/Documents/go/"
PARENT_GROUP_ID="123"
GITLAB_ADDRESS="gitlab.***.com"

function clone_projects {
  local GROUP_ID="$1"
  local PARENT_PATH="$2"
  local SUBGROUP_PATH="$3"  
  
  # GitLab API endpoint for group projects
  API_ENDPOINT="https://${GITLAB_ADDRESS}/api/v4/groups/${GROUP_ID}/projects?private_token=${GITLAB_TOKEN}"

  # Fetch the project list using the API
  PROJECTS=$(curl "${API_ENDPOINT}")

  # Loop through the projects and clone each one
  for project in $(echo "${PROJECTS}" | jq -r '.[].ssh_url_to_repo'); do
    git clone "${project}" 
  done

  # Fetch the list of subgroups
  local SUBGROUPS=$(curl "https://${GITLAB_ADDRESS}/api/v4/groups/${GROUP_ID}/subgroups?private_token=${GITLAB_TOKEN}")

  # Loop through subgroups and recursively clone projects
  for subgroup in $(echo "${SUBGROUPS}" | jq -r '.[].id'); do
    local NEW_SUBGROUP_PATH="$(echo "${SUBGROUPS}" | jq -r --argjson s "${subgroup}" '.[] | select(.id == $s) | .full_path' )"
    echo "${ABSOULTE_PATH}""${NEW_SUBGROUP_PATH}"
    mkdir -p "${ABSOULTE_PATH}""${NEW_SUBGROUP_PATH}"
    cd "${ABSOULTE_PATH}""${NEW_SUBGROUP_PATH}"
    clone_projects "${subgroup}" "${NEW_SUBGROUP_PATH}"
  done
}

# GitLab API endpoint for parent group information
PARENT_GROUP_INFO=$(curl "https://${GITLAB_ADDRESS}/api/v4/groups/${PARENT_GROUP_ID}?private_token=${GITLAB_TOKEN}")
# echo "${PARENT_GROUP_INFO}"
# Extract parent group path from the API response
PARENT_GROUP_PATH=$(echo "${PARENT_GROUP_INFO}" | jq -r '.full_path')
# echo "${PARENT_GROUP_PATH}"
# Create a folder for the parent group
echo "${ABSOULTE_PATH}""${PARENT_GROUP_PATH}"
mkdir -p "${ABSOULTE_PATH}""${PARENT_GROUP_PATH}"

# Clone projects for the parent group
cd "${ABSOULTE_PATH}""${PARENT_GROUP_PATH}"
clone_projects "${PARENT_GROUP_ID}" "${PARENT_GROUP_PATH}"
