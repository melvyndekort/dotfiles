#!/bin/sh

cat $HOME/.config/aws/mdekort > $HOME/.config/aws/config

echo >> $HOME/.config/aws/config

granted sso login --sso-start-url https://portbase.awsapps.com/start --sso-region eu-west-1
granted sso generate --sso-region eu-west-1 https://portbase.awsapps.com/start >> $HOME/.config/aws/config
