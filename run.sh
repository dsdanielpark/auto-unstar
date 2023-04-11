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