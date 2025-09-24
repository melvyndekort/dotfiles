#!/bin/sh

# Get YubiKey serial number dynamically
SERIAL=$(ykman info 2>/dev/null | grep "Serial number:" | awk '{print $3}')

if [ -z "$SERIAL" ]; then
    echo "Error: No YubiKey detected" >&2
    exit 1
fi

# Find libykcs11.so location
PKCS11_LIB=$(ldconfig -p | grep libykcs11.so | awk '{print $NF}' | head -1)

if [ -z "$PKCS11_LIB" ]; then
    echo "Error: libykcs11.so not found" >&2
    exit 1
fi

aws_signing_helper credential-process \
  --pkcs11-lib "$PKCS11_LIB" \
  --certificate "pkcs11:token=YubiKey%20PIV%20%23${SERIAL};object=X.509%20Certificate%20for%20PIV%20Authentication" \
  --private-key "pkcs11:token=YubiKey%20PIV%20%23${SERIAL};id=%01" \
  --reuse-pin \
  --region "eu-west-1" \
  --trust-anchor-arn "arn:aws:rolesanywhere:eu-west-1:075673041815:trust-anchor/3f2731d8-2eb5-4e8a-a1fb-643a6d239e23" \
  --profile-arn "arn:aws:rolesanywhere:eu-west-1:075673041815:profile/159ec173-e450-4ab4-8e7b-ce423ed3bdc7" \
  --role-arn "arn:aws:iam::075673041815:role/YubikeyRole"
