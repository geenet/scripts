#!/bin/bash
#----------------------------------------------------------------------#
# Script to get all repositories under a user from bitbucket
# Source Code credits and tips:
# http://haroldsoh.com/2011/10/07/clone-all-repos-from-a-bitbucket-source/
# https://movingtothedarkside.wordpress.com/2015/01/10/clone-all-repositories-from-a-user-bitbucket/

read -r -d '' HELPTEXT << "EOM"

Usage:
   ./bitbucket_clones_all_repositories.sh <user> <destination>
   
Example:
   ./bitbucket_clones_all_repositories.sh geenet ~/code/bitbucket/


EOM

user_name="${user_name}"
if [ -z "$user_name" ]; then
    user_name="${1}"
fi;
#user_name="${1}"
destination="${2}"
#url="https://api.github.com/users/${user_name}/repos";
#max_pages=$(curl -sI "$url?page=1&per_page=100" | sed -nr 's/^Link:.*page=([0-9]+)&per_page=100>; rel="last".*/\1/p');
#echo "##$url?page=1&per_page=100#";

if [ -z "$user_name" ]; then
    echo "$HELPTEXT"
    exit;
fi;

if [ -z "$destination" ]; then
    destination='./';
fi;

echo "cloning bitbucket user ${user_name} repos to $destination ..."
mkdir -p "$destination"
cd "$destination"

curl -u ${user_name} https://api.bitbucket.org/1.0/users/${user_name} > /tmp/bitbucket-repoinfo
# curl -u adomingues https://api.bitbucket.org/1.0/users/adomingues
# cat repoinfo
 
for repo_name in `cat /tmp/bitbucket-repoinfo | sed -r 's/("name": )/\n\1/g' | sed -r 's/"name": "(.*)"/\1/' | sed -e 's/{//' | cut -f1 -d\" | tr '\n' ' '`
do
    echo "git clone ssh://git@bitbucket.org/${user_name}/$repo_name.git ... "
    git clone ssh://git@bitbucket.org/${user_name}/$repo_name.git
done

echo "done"
