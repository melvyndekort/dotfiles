#!/bin/bash

BASEDIR=$PWD
REPOLIST=$(gh repo list melvyndekort --json name,isArchived -q '.[] | select(.isArchived == false) | .name' | sort)
ARCHIVED_REPOS=$(gh repo list melvyndekort --json name,isArchived -q '.[] | select(.isArchived == true) | .name' | sort)
SIZE=$(echo $REPOLIST | wc -w)
COUNT=1

for REPO in $REPOLIST; do
  if [ -d "$REPO" ]; then
    echo "Updating $REPO (${COUNT}/${SIZE})"
    cd $REPO
    git config user.email 'melvyn@mdekort.nl'
    ( git branch --no-color --show-current | grep -q main ) && git pull -q
    cd $BASEDIR
  else
    echo "Cloning $REPO (${COUNT}/${SIZE})"
    gh repo clone $REPO -- --quiet
    cd $REPO
    git config user.email 'melvyn@mdekort.nl'
    cd $BASEDIR
  fi
  COUNT=$((COUNT + 1))
done

DIRLIST=$(ls -d */ | xargs | tr -d '/' | sort)
for REPO in $REPOLIST; do
  DIRLIST=$(echo ${DIRLIST/$REPO/})
done

ARCHIVED_ON_DISK=""
for REPO in $ARCHIVED_REPOS; do
  if [ -d "$REPO" ]; then
    ARCHIVED_ON_DISK="$ARCHIVED_ON_DISK $REPO"
  fi
done

UNMANAGED=$(echo "$DIRLIST $ARCHIVED_ON_DISK" | tr ' ' '\n' | grep -v '^$' | sort -u | tr '\n' ' ')

if [ -n "$UNMANAGED" ]; then
   echo "Repositories which aren't managed: $UNMANAGED"
fi

