#!/bin/sh

set -e

owncloudcmd -s -ds -n $HOME/.secure https://lordmatanza.stackstorage.com/remote.php/webdav/secure
