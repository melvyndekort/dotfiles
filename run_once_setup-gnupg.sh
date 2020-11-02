#!/bin/sh

set -e

lpass show --field="Private Key" "GPG melvyn@mdekort.nl" | gpg --import -

echo
echo
echo '============================================================================'
echo '  Now importing the private GPG key, you need to ultimately trust the key:'
echo '    # enter 5<RETURN>'
echo '    # enter y<RETURN>'
echo '============================================================================'
echo
echo

export XDG_DATA_HOME=$HOME/.local/share
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
gpg --edit-key melvyn@mdekort.nl trust quit
