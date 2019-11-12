#!/bin/sh

set -e

lpass show --field="Private Key" "GPG melvyn@mdekort.nl" | gpg --import -
#gpg --command-fd 0 --expert --edit-key "melvyn@mdekort.nl" trust

for fpr in $(gpg --list-keys --with-colons melvyn@mdekort.nl | awk -F: '/fpr:/ {print $10}' | sort -u); do
  echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key $fpr trust
done
