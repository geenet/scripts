#!/bin/bash
#Script to get all repositories under a user from bitbucket
#Usage: getAllRepos.sh [username]
#source: http://haroldsoh.com/2011/10/07/clone-all-repos-from-a-bitbucket-source/
#https://movingtothedarkside.wordpress.com/2015/01/10/clone-all-repositories-from-a-user-bitbucket/
 
curl -u ${1} https://api.bitbucket.org/1.0/users/${1} > repoinfo
# curl -u adomingues https://api.bitbucket.org/1.0/users/adomingues
# cat repoinfo
 
for repo_name in `cat repoinfo | sed -r 's/("name": )/\n\1/g' | sed -r 's/"name": "(.*)"/\1/' | sed -e 's/{//' | cut -f1 -d\" | tr '\n' ' '`
do
    echo "Cloning " $repo_name
    #hg clone https://${1}@bitbucket.org/${1}/$repo_name
    git clone ssh://git@bitbucket.org/${1}/$repo_name.git
    echo "---"
done



