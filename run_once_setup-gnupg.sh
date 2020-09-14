#!/bin/sh

set -e

lpass show --field="Private Key" "GPG melvyn@mdekort.nl" | gpg --import -

echo
echo 'Please trust the imported private key:'
echo '  gpg --edit-key melvyn@mdekort.nl'
echo
echo '# at the prompt: trust'
echo '# choose option 5'
