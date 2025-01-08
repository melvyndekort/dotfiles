#!/bin/bash

# Function to encode URL parameters
urlencode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    for (( i = 0; i < strlen; i++ )); do
        local c="${string:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            *) encoded+=$(printf '%%%02X' "'$c") ;;
        esac
    done
    echo "$encoded"
}

# Prompt for a session name
read -p "Enter a session name (e.g., ConsoleSession): " SESSION_NAME

# Generate federated token
echo "Generating federated token..."
FEDERATION_OUTPUT=$(aws sts get-federation-token --name "$SESSION_NAME" --policy '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":"*","Resource":"*"}]}' --duration-seconds 3600 --output json)

if [ $? -ne 0 ]; then
    echo "Failed to generate federated token. Please check your credentials."
    exit 1
fi

# Extract temporary credentials
TEMP_ACCESS_KEY=$(echo "$FEDERATION_OUTPUT" | jq -r '.Credentials.AccessKeyId')
TEMP_SECRET_KEY=$(echo "$FEDERATION_OUTPUT" | jq -r '.Credentials.SecretAccessKey')
SESSION_TOKEN=$(echo "$FEDERATION_OUTPUT" | jq -r '.Credentials.SessionToken')

# Construct a sign-in URL
echo "Creating sign-in URL..."
SIGNIN_TOKEN=$(curl -s -X POST \
    --data-urlencode "Action=getSigninToken" \
    --data-urlencode "Session=$(jq -n --arg AccessKeyId "$TEMP_ACCESS_KEY" \
                                       --arg SecretAccessKey "$TEMP_SECRET_KEY" \
                                       --arg SessionToken "$SESSION_TOKEN" \
                                       '{"sessionId":$AccessKeyId,"sessionKey":$SecretAccessKey,"sessionToken":$SessionToken}')" \
    https://signin.aws.amazon.com/federation)

SIGNIN_TOKEN=$(echo "$SIGNIN_TOKEN" | jq -r '.SigninToken')

if [ -z "$SIGNIN_TOKEN" ]; then
    echo "Failed to create sign-in token."
    exit 1
fi

# Generate the AWS Management Console URL
CONSOLE_URL="https://signin.aws.amazon.com/federation?Action=login&Issuer=Script&Destination=$(urlencode "https://console.aws.amazon.com/")&SigninToken=$SIGNIN_TOKEN"

echo "AWS Console URL: $CONSOLE_URL"
echo "Copy and paste the URL above into your browser to log in."

