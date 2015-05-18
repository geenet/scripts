#!/bin/bash
#----------------------------------------------------------------------#
# Script to get all repositories under a user from github
# Snippet code credits and tips:
#  https://gist.github.com/michfield/4525251

read -r -d '' HELPTEXT << "EOM"

Usage:
   ./github_clones_all_repositories.sh <user> <destination>
   
Example:
   ./github_clones_all_repositories.sh guguncube ~/code/github/

 Please NOTE that github heavily throttles the amount of calls you can make.
 Therefore, clone can stop working after too many successive attempts
 
 See also: https://developer.github.com/v3/#rate-limiting 
 
EOM
user_name="${1}"
destination="${2}"
url="https://api.github.com/users/${user_name}/repos";
max_pages=$(curl -sI "$url?page=1&per_page=100" | sed -nr 's/^Link:.*page=([0-9]+)&per_page=100>; rel="last".*/\1/p');
#echo "##$url?page=1&per_page=100#";

if [ -z "$user_name" ]; then
   echo "$HELPTEXT"
   exit;
fi;

if [ -z "$max_pages" ]; then
   max_pages=1;
fi;

if [ -z "$destination" ]; then
   destination='./';
fi;

echo "cloning github user ${user_name} repos to $destination ..."
mkdir -p "$destination"
cd "$destination"


for ((i=1; i<=$max_pages; i++)); do
   repo_list_in_page=$(curl -s "$url?page=${i}&per_page=100" | grep "clone_url" | sed -nr 's/.*clone_url": "(.*)",/git clone \1/p');
   echo "$repo_list_in_page"
   /bin/bash -c "$repo_list_in_page";
done

echo "done"

