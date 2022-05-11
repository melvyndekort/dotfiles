#!/bin/sh

for REPO in ${PWD}/*/; do
  cd $REPO
  echo Processing $REPO

  ## Set correct e-mail address
  git config user.email 'melvyn@mdekort.nl'

  ## Update repo
  git branch --no-color --show-current | grep -q main
  if [ $? -eq 0 ]; then
    git pull -q
  fi
done

