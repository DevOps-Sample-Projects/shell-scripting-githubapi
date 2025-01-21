#!/bin/bash
#
######################
#Author : Chaitanya
#Date 21 Jan 2025
#Purpose : Shell Script to list the users having access to a repo
####################
#

helper
#GitHub API url
APIURL="https://api.github.com"

#Github user name and personal access token

USERNAME=$user
TOKEN=$token

#Organisation and repo information
ORGNAME=$1
REPONAME=$2

#Function to make a get request to the github API
function github_get_api {
	local endpoint="$1"
	local url="${APIURL}/${endpoint}"
	#send a GET request to API with authentication
	
	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

#Function to list users of the repository
function list_users_of_repo {
	local endpoint="repos/${ORGNAME}/${REPONAME}/collaborators"

	#fetch list of collaborators of the repo
	collaborators="$(github_get_api "$endpoint" | jq -r '.[] | select(.permissions.admin == true) | .login')"

	#display the lust of collaborators with read access
	if [[ -z "$collaborators" ]]; then
		echo "No users with read access for ${ORGNAME}/${REPONAME}"
	else
		echo "users list with read access to ${ORGNAME}/${REPONAME}"
		echo "$collaborators"

	fi
}
#Main script
echo "Listening to repo for users with read access"
list_users_of_repo

function helper {
	expected_args="2"
	if [ $# -ne $expected_args]; then
		echo "please enter orgname and reponame as args"
	fi
}
