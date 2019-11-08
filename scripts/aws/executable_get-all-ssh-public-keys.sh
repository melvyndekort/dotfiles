#!/bin/sh

for USERNAME in $(aws iam list-users | jq -r '.Users[].UserName'); do
  for KEYID in $(aws iam list-ssh-public-keys --user-name $USERNAME | jq -r '.SSHPublicKeys[].SSHPublicKeyId'); do
    aws iam get-ssh-public-key --user-name $USERNAME --ssh-public-key-id $KEYID --encoding SSH | jq -r '.SSHPublicKey.SSHPublicKeyBody' | ssh-keygen -l -E sha256 -f - | sed "s/no comment/$USERNAME $KEYID/g"
  done
done
