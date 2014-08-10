#!/bin/bash
#date parameters have to be escaped in order to work
# crontab -e
#30 16 * * * /bin/bash +x /home/path/to/jobs/delete-old-files.sh  > "/home/path/to/jobs/logs/delete-old-files.$(date +\%Y-\%m-\%d_\%H\%M).log" 2>&1
# crontab -l
   
age="30"
dirs=("/home/me/apps" "/var/log");
files=(".*\.bz2" ".*\.log");

for i in "${!dirs[@]}"; do
  echo "$i:~\$ find \"${dirs[$i]}\" -iregex \"${files[$i]}\$\" -type f -mtime \"+${age}\" -exec ls -l \"{}\" \;"
  # print matching files
  find "${dirs[$i]}" -iregex "${files[$i]}$" -type f -mtime "+${age}" -exec ls -l "{}" \;
  # remove files found
  #find "${dirs[$i]}" -iregex "${files[$i]}$" -type f -mtime "+${age}" -exec rm "{}" \;
done

