# AutoUnstar
It represents the automatic un-starring feature for GitHub repositories. Using the following Bash script, you can easily collect all starred repositories and display them in a `stars.txt` file. Then, unstar the repositories listed in the `stars.txt` file.


# Quick Start
1. Get Github API Autorization `Token` from https://github.com/settings/tokens.
2. Using this command.
```
$ git clone https://github.com/DSDanielPark/AutoUnstar.git
$ cd AutoUnstar
$ export APIKEY=xxxxxxxxxxxxxxxxxxxx
$ bash run.sh
```


# Manually
## How to unstar all repository. 
Reference: https://gist.github.com/justlaputa/a6da84981eca963817e652b5f2452cfc

1. Generate authorization `token` for unstar.
https://github.com/settings/tokens 

2. Export variable
```wsl
export APIKEY=xxxxxxxxx
```

3. Gain access to the starred repositories page.
```wsl
curl -I -H "Authorization: token $APIKEY" https://api.github.com/user/starred
```

4. Retrieve the list of starred repositories and save it to a file called `stars.txt`.
```wsl
for p in `seq 1 4`;do
echo page 
curl -s -H "Authorization: token $APIKEY" https://api.github.com/user/starred\?page\=$p | jq -r '.[] |.full_name' >>stars.txt
done
```

5. Unstar any repositories that are listed in the `stars.txt` file.
```wsl
while read REPO;do
echo 
curl -X DELETE -s -H "Authorization: token $APIKEY" https://api.github.com/user/starred/$REPO
sleep .5
done<stars.txt
```




## Shell Script
```shell
#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


STARS_PAGE_COUNT=20
STARS_FILE=stars.txt
DELETE_SLEEP_TIME=.5

function get_all_star_repos() {
  for p in $(seq 1 $STARS_PAGE_COUNT);do
    echo "page: $p"
    curl -s -H "Authorization: token $APIKEY" https://api.github.com/user/starred\?page\=$p | jq -r '.[] |.full_name' >> $STARS_FILE
  done
}

function remove_all_star_repos() {
  while read REPO;do
    echo "REPO: $REPO"
    curl -X DELETE -s -H "Authorization: token $APIKEY" https://api.github.com/user/starred/$REPO
    sleep $DELETE_SLEEP_TIME
  done < $STARS_FILE
}

get_all_star_repos
remove_all_star_repos
```

Reference: 
[1] https://gist.github.com/justlaputa/a6da84981eca963817e652b5f2452cfc <br>
[2] https://gist.github.com/f9n
